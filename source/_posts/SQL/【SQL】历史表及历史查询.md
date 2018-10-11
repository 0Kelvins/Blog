---
title: 【SQL】历史表及历史查询
comments: true
categories: SQL
tags:
  - SQL
  - 分表
abbrlink: ad7c26a4
date: 2018-09-12 17:13:53
---

存在原子记录表，数据量月累计最大千万，不能使用分区，不至于分布式存储，于是使用历史记录转存历史表方案
<!-- more -->

### 流程

1. 动态创建历史表，并转存历史数据的存储过程

```sql
CREATE PROCEDURE [dbo].[P_W_QuestionHisRedeposit]
AS
BEGIN
	DECLARE @lastMonth DATETIME, @tableDate NVARCHAR(10), @tableName NVARCHAR(50), @sql NVARCHAR(2000), @error INT;
	SET @lastMonth = DATEADD(MONTH, -1, GETDATE()); -- 上月同一天
	SET @tableDate = CONVERT(VARCHAR(10), DATEADD(MONTH, DATEDIFF(MONTH, 0, @lastMonth), 0), 120); -- 上月第一天
	SET @tableName = '[dbo].[Question_His_' + @tableDate + ']'; -- 历史表名
	SET @error = 0; -- 是否有错

    -- 检查历史表是否已存在，月定时作业执行，应不会重复
	IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@tableName) AND type IN (N'U'))
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION
                -- 建表
				SET @sql = 'CREATE TABLE ' + @tableName + ' (
					[Id] [INT],
					[QuestionID] [VARCHAR](500),
					[Answers] [VARCHAR](MAX),
					[Result] [FLOAT],
					[UserID] [VARCHAR](100),
					[RecordTime] [DATETIME]
				)';
				EXECUTE(@sql);
				SET @error = @error + @@ERROR;

                -- 转存前一个月的历史数据
				SET @sql = 'INSERT INTO '+ @tableName +' SELECT * FROM [dbo].[Question_His]'
						 + ' WHERE DATEDIFF(MONTH, [RecordTime], GETDATE()) >= 1';
				EXECUTE(@sql);
				SET @error = @error + @@ERROR;

                -- 删除历史表一个月前数据
				SET @sql = 'DELETE FROM [dbo].[Question_His] WHERE DATEDIFF(MONTH, [RecordTime], GETDATE()) >= 1';
				EXECUTE(@sql);
				SET @error = @error + @@ERROR;
			COMMIT
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 -- 失败回滚
				ROLLBACK

			DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT
			SELECT @ErrMsg = ERROR_MESSAGE(),
				   @ErrSeverity = ERROR_SEVERITY()

			RAISERROR(@ErrMsg, @ErrSeverity, 1)
		END CATCH
	END
END
```

2. 创建每月作业，创建执行转存历史的存储过程，建议使用DBMS操作，简单方便
    
    入口：SQL Server 代理 -> 新建作业

    关键的地方：

    2.1 新建步骤【选择T-SQL; 选择执行数据库; 命令如下;】

    ```sql
    EXEC [dbo].[P_W_LP_QuestionHisRedeposit]
    ```

    2.2 新建计划 -> 频率，执行：天 `1` 每 `1` 个月，


3. 历史数据查询存储过程，使用时间筛选查询表

```sql
CREATE PROC [dbo].[P_HisTableQuery]
(
@TableNamePrefix NVARCHAR(100),  -- 历史表名
@TimeColumnName NVARCHAR(100),   -- 时间列
@FromTime DATETIME,              -- 开始时间
@ToTime DATETIME,                -- 截止时间
@QueryCondition NVARCHAR(MAX) = '' -- 其他查询条件，要格外注意字符串的引号转义问题
)
AS
BEGIN
	DECLARE @tableName NVARCHAR(100), @sql NVARCHAR(max)
	SET @tableName = ''
	SET @sql = ''

    -- 查出时间内所有历史表名
	DECLARE t_cursor CURSOR FOR SELECT name FROM sys.tables WHERE name IN (
		SELECT name FROM sys.tables
		 WHERE name = @TableNamePrefix 
		 UNION 
		SELECT name FROM sys.tables
		 WHERE name LIKE @TableNamePrefix+'_%' AND ISDATE(RIGHT(name, 10)) = 1
		   AND CONVERT(DATETIME, CAST(RIGHT(name, 10) AS VARCHAR(10)), 120) >= @FromTime 
		   AND CONVERT(DATETIME, CAST(RIGHT(name, 10) AS VARCHAR(10)), 120) <= @ToTime
	)

    -- 拼接各历史表查询结果
	OPEN t_cursor
	FETCH NEXT FROM t_cursor INTO @tableName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sql += + ' UNION SELECT * FROM [' + @tableName + ']'
					+ ' WHERE [' + @TimeColumnName + '] >= ''' + CONVERT(VARCHAR(20), @FromTime, 120) + ''''
					+ ' AND [' + @TimeColumnName + '] <= ''' + CONVERT(VARCHAR(20), @ToTime, 120) + ''''
					+ @QueryCondition
	FETCH NEXT FROM  t_cursor INTO @tableName
	END
	CLOSE t_cursor
	DEALLOCATE t_cursor

	SET @sql = SUBSTRING(@sql, 7, LEN(@sql)); -- 截掉最开始的UNION，可以重复使用UNION ALL

	EXEC(@sql)
END
```

### 小结

有条件（可以分区or搞分布式）就不要这样搞，开发维护起来太麻烦了(╯‵□′)╯︵┻━┻