---
title: 【SQL】循环游标遍历
comments: true
categories: SQL
tags:
  - SQL
  - T-SQL
  - SQL Server
abbrlink: c638d2ec
date: 2018-02-01 20:13:18
---
### 记录
用循环（ `WHILE` ）游标（ `CURSOR` ）实现，遍历系统视图，取出（ `FETCH` ）每条数据并计数+1（这里只是用来记下怎么用，查数量肯定还是用 `COUNT()` 。

```sql
CREATE PROCEDURE P_CHECK_DB_NUM
AS
BEGIN
    DECLARE @num INT, @error INT
    DECLARE @temp VARCHAR(50)
    SET @num = 1
    SET @error = 0
    --申明游标为db_cursor
    DECLARE db_cursor CURSOR
		FOR (SELECT [name] FROM [master].[sys].[databases])
    --打开游标--
    OPEN db_cursor
    --开始循环游标变量--
    FETCH NEXT FROM db_cursor INTO @temp
    WHILE @@FETCH_STATUS = 0    --返回被 FETCH语句执行的最后游标的状态--
        BEGIN            
            SET @num = @num + 1
            SET @error = @error + @@ERROR   --记录每次运行sql后是否正确，0正确
            FETCH NEXT FROM db_cursor INTO @temp   --转到下一个游标，没有会死循环
        END   
    CLOSE db_cursor  --关闭游标
    DEALLOCATE db_cursor   --释放游标

	RETURN @num;
END
```

### 后言
自从当初学完以后就好像没再用过了，今天偶然想起来，记录一下用法。