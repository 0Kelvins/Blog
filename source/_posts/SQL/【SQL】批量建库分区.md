---
title: 【SQL】批量建库分区
comments: true
categories: SQL
tags:
  - SQL
  - 分区
abbrlink: 170e08d7
date: 2018-08-30 19:49:56
---

表分区过程是为单个数据库建立多个 `文件组（夹）` 及里面的 `文件` ，然后把表内数据按照 `分区函数` 和 `方案` ，放到不同的数据库文件里。通过这样的处理，使得表的数据、索引等分成多个部分，缓解单表过大导致检索太慢等问题。
<!-- more -->

## 环境
SQL Server 2008 R2

## 流程及脚本

### 1. 建库、文件组及文件

建库前要求先建好目录，然后修改下面脚本建立自己的库（注意下面脚本反斜杠替换为单个）

```sql
USE master
GO

DECLARE @DbName VARCHAR(max), @Path NVARCHAR(1000), @InitSize VARCHAR(50), @FileGrowth VARCHAR(50)
SELECT @Path = 'D:\\PulicDataBase\\',	-- 指定根路径(\\, hight light fix, 请自行替换为单反斜杠，下同)
	   @InitSize = '5MB', @FileGrowth = '10%';

-- 指定数据库名称，多个用逗号隔开

SELECT @DbName	= 'DBTest, DBTest2';
				
BEGIN
	-- 定义数据库名称临时表@temp
	DECLARE @temp TABLE
	(
		ID INT IDENTITY(1,1),	--自动编号（获知顺序）
		Result VARCHAR(MAX)		--拆分后结果
	);
	DECLARE @i INT, @SourceSql VARCHAR(max), @target NVARCHAR(MAX), @StrSeprate VARCHAR(10)
    SELECT @SourceSql = LTRIM(RTRIM(@DbName)), @StrSeprate=','	--指定源字符串、分隔符
    IF RIGHT(@SourceSql, LEN(@StrSeprate)) <> @StrSeprate	SET @SourceSql= @SourceSql + @StrSeprate
    SET @i = CHARINDEX(@StrSeprate,@SourceSql)
    WHILE @i >= 1
    BEGIN
        SET @target = LTRIM(RTRIM(left(@SourceSql, @i-1)))
        IF @target IS NOT NULL AND @target <> ''	INSERT @temp VALUES(@target)
		ELSE  INSERT @temp VALUES(NULL)
        SET @SourceSql = SUBSTRING(@SourceSql, @i+1, LEN(@SourceSql)-@i)
        SET @i = CHARINDEX(@StrSeprate,@SourceSql)
    END

	--开始遍历@temp建库
	DECLARE @DataBaseName NVARCHAR(50), @sql NVARCHAR(MAX), @DBPath NVARCHAR(500)	
	DECLARE @i_Group INT			--文件组个数
	DECLARE @Flag VARCHAR(10)		--数据库标识

	IF RTRIM(LTRIM(ISNULL(@Path, ''))) = ''	SET @Path = 'D:\\PulicDataBase\\'
	SET @Path = RTRIM(LTRIM(@Path))
	IF RIGHT(@Path, 1) <> '\\'	SET @Path = @Path + '\\'
	SELECT * FROM @temp
	DECLARE db_cursor CURSOR FOR SELECT Result FROM @temp WHERE ISNULL(Result, '') <> '' ORDER BY ID
	--开始游标
	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO @DataBaseName
	WHILE @@fetch_status = 0 
	BEGIN
		BEGIN TRY		
			IF CHARINDEX('DBTest', @DataBaseName) > 0 SET @DBPath = @Path + 'DBTest' + '\\'	--数据库目录

			IF EXISTS(SELECT * FROM sysdatabases WHERE name = @DataBaseName) 
			BEGIN
				PRINT '【创建数据库】'+ @DataBaseName +'已存在，不必重复创建！'  
				FETCH NEXT FROM db_cursor INTO @DataBaseName
				CONTINUE;
			END
			ELSE
			BEGIN
				SET @sql='create database ['+ @DataBaseName + '] on primary
				(
					name=N'''+ @DataBaseName +''',
					filename=N'''+ @DBPath + @DataBaseName +'.mdf'',
					size='+ @InitSize +',
					filegrowth='+ @FileGrowth +'
				)
				log on
				(
					name=N'''+ @DataBaseName +'_Log'',
					filename=N'''+ @DBPath + @DataBaseName +'_Log.ldf'',
					size='+ @InitSize +',
					filegrowth='+ @FileGrowth +'
				)'
				EXECUTE (@sql)
				PRINT '【创建数据库】'+ @DataBaseName +'创建成功！'
			END
	
			--创建指定数据库文件组及文件
			SELECT @i_Group = 1, @Flag = '1'
			IF CHARINDEX(','+ @DataBaseName +',',','+ 'DBTest, DBTest2' +',') > 0
			BEGIN
				WHILE @i_Group<=11
				BEGIN
					SET @sql = 'IF NOT EXISTS(SELECT * FROM sysfilegroups sp_helpfilegroup WHERE groupname = ''FileGroup_' + @Flag + '_' + CAST(@i_Group AS VARCHAR(10)) +''') '
							+ 'ALTER DATABASE ['+ @DataBaseName +'] ADD FILEGROUP FileGroup_' + @Flag + '_' + CAST(@i_Group AS VARCHAR(10)) + ' '
							+ 'IF NOT EXISTS(SELECT * FROM sys.database_files WHERE name = ''' + @DataBaseName + '_File_' + CAST(@i_Group AS VARCHAR(10)) +''') '
							+ 'ALTER DATABASE ['+ @DataBaseName +'] ADD FILE (name = ''' + @DataBaseName + '_File_' + CAST(@i_Group AS VARCHAR(10)) +''', filename = ''' + @DBPath + @DataBaseName + '_File_' + CAST(@i_Group AS VARCHAR(10)) + '.mdf'', maxsize = UNLIMITED, filegrowth = 10%) to filegroup [FileGroup_' + @Flag + '_' + CAST(@i_Group AS VARCHAR(10)) +']'
		
					EXECUTE (@sql)
					SET @i_Group = @i_Group + 1
				END
			END
		END TRY
		BEGIN CATCH
			PRINT '【创建数据库】'+ @DataBaseName + '创建时出错：' + ERROR_MESSAGE()
			FETCH NEXT FROM db_cursor INTO @DataBaseName
			CONTINUE
		END CATCH
	FETCH NEXT FROM db_cursor INTO @DataBaseName
	END
	CLOSE db_cursor
	DEALLOCATE db_cursor
END
GO
```

### 2. 创建分区函数及方案

```sql
USE DBTest
GO

-- 表分区函数
IF NOT EXISTS (SELECT * FROM sys.partition_functions WHERE name='PF_PRE_FIVEMILLOIN')
BEGIN
	CREATE PARTITION FUNCTION PF_PRE_FIVEMILLOIN(INT)
	AS RANGE LEFT
	FOR VALUES(5000000, 10000000, 15000000, 20000000, 25000000, 30000000, 35000000, 40000000, 45000000, 50000000)
END
--表分区方案
IF NOT EXISTS (SELECT * FROM sys.partition_schemes WHERE name='PS_ALL_GROUP')
BEGIN
	CREATE PARTITION SCHEME PS_ALL_GROUP
	AS PARTITION PF_PRE_FIVEMILLOIN
	TO (FileGroup_843_1, FileGroup_843_2, FileGroup_843_3, FileGroup_843_4, FileGroup_843_5, FileGroup_843_6, FileGroup_843_7, FileGroup_843_8, FileGroup_843_9, FileGroup_843_10, FileGroup_843_11)
END
GO
```

### 3. 建表，使用分区索引

```sql
--建表
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[T_Test]') AND type IN (N'U'))
BEGIN
CREATE TABLE [dbo].T_Test(
	[Id] [INT] NOT NULL,
	[No] [VARCHAR](50) NOT NULL,
	[Name] [VARCHAR](1000) NULL,
	[RecordTime] [DATETIME] NOT NULL,
	CONSTRAINT [PK_T_Test] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PS_ALL_GROUP]([Id])
 )
END
GO
-- 索引
IF NOT EXISTS (SELECT * FROM SYSINDEXES WHERE NAME='IX_T_Test_No_Time')
	CREATE NONCLUSTERED INDEX IX_T_Test_No_Time ON [dbo].[T_Test ]
	(
	    [No] ASC,
	    [RecordTime] DESC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PS_ALL_GROUP]([Id])
GO
```

### 4. 查看表各分区记录情况

```sql
SELECT $partition.PF_PRE_FIVEMILLOIN(Id) AS PartitionNumber, count(*) AS RecordCount
FROM T_Test
GROUP BY $partition.PF_PRE_FIVEMILLOIN(Id)
```

## 小记

在目前项目中，某些数据会存在积累速度快，但是需要长时间保存的情况，所以为对应表进行分区。如果所有的表都有大数据的压力，那就考虑数据库集群吧。

考虑到单表数据量还是不会减少，所以这并不能满足大数据量的单表做到用户是实时交互体验，如果有必要，需要做部分数据缓存，如果要统计需要做定时统计结果缓存等等。

分区数量最好考虑到服务器的CPU核数，考虑索引和分区函数方案的效果等等。

如果数据不能清理，始终会增加，考虑按月按年分区，可以使用作业计划调用动态建立文件（组）及表分区的存储过程来实现。