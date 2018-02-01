---
title: 【SQL】SQL-Server递归查询
comments: true
categories: SQL
tags:
  - SQL
  - SQL Server
abbrlink: 83629cbf
date: 2018-01-30 19:52:08
---
### 需求
有一张国内区域表，要查询一个区域及其子区域的区域编码

效果：
![区域表查询效果](/assets/images/sql_recursive_query_region/sql_recursive_query_region.png)

表结构：
```sql
CREATE TABLE [dbo].[Region](
	[REGION_ID] [int] PRIMARY KEY NOT NULL,
	[REGION_CODE] [varchar](100) NOT NULL,
	[REGION_NAME] [varchar](100) NOT NULL,
	[PARENT_ID] [int] NOT NULL,
	[REGION_LEVEL] [int] NOT NULL,
	[REGION_ORDER] [int] NOT NULL,
	[REGION_NAME_EN] [varchar](100) NOT NULL,
	[REGION_SHORTNAME_EN] [varchar](10) NOT NULL
)
```

`PARENT_ID`为父区域的`REGION_ID`，这种结构就让我想能不能递归查询，减少连接数据库进行查询请求的次数。

### 参考
[使用公用表表达式的递归查询 —— technet，microsoft](https://technet.microsoft.com/zh-cn/library/ms186243(v=sql.105).aspx)
[SQL递归查询知多少 —— 圣杰，博客园](https://www.cnblogs.com/sheng-jie/p/6347835.html)

### 实现方法
使用多次查询虽然可以完成，但是效率不够高，并且代码冗余，`SQL Server`使用公用表表达式（Common Table Expression，CTE）可以实现递归查询
```sql
CREATE PROCEDURE [dbo].[P_REGION] @RegionCode VARCHAR(50)='' AS
BEGIN

WITH CTE_REGION(REGION_ID, REGION_CODE, REGION_NAME, PARENT_ID, REGION_LEVEL, REGION_ORDER, REGION_NAME_EN, REGION_SHORTNAME_EN) AS
(
    SELECT REGION_ID, REGION_CODE, REGION_NAME, PARENT_ID, REGION_LEVEL, REGION_ORDER, REGION_NAME_EN, REGION_SHORTNAME_EN
	  FROM [dbo].[Region]
	 WHERE REGION_LEVEL < 3 AND REGION_CODE = @RegionCode
    UNION ALL
    SELECT a.REGION_ID, a.REGION_CODE, a.REGION_NAME, a.PARENT_ID, a.REGION_LEVEL, a.REGION_ORDER, a.REGION_NAME_EN, a.REGION_SHORTNAME_EN
	  FROM [dbo].[Region] a
		  INNER JOIN CTE_REGION b
		  ON a.PARENT_ID = b.REGION_ID
)


SELECT REGION_CODE FROM CTE_REGION

END
```