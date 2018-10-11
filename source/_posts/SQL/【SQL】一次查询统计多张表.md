---
title: 【SQL】一次查询统计多张表
comments: true
categories: SQL
tags: SQL
abbrlink: 41b37696
date: 2018-01-11 11:26:16
---

### 需求

> 一次查询统计所有用户每天的事件A（表A）、事件B（表B）和事件C（表C）的数量以及三种事件的总量
<!-- more -->

环境：SQL Server

### 实现
**思路：** 三种子查询后联表

**问题：** 没有一个的日期表来作为联表的基准表，以A表为基准表会缺失A表内没有的日期，如何补全

**解决方法：** 没有的就用其他表的补上，需要知道`ISNULL()`方法或着使用条件判断语句`case when 条件1 then 结果1 when 条件2 then 结果2 else 结果N end`来判断A表是否没有对应列数据，然后补全B或C表对应列

**实现：**
```sql
	SELECT temp.[UserID],
		   CONVERT(DATE, temp.[DateTime]) AS [DateTime],
		   temp.[AEventNumber],
		   temp.[BEventNumber],
		   temp.[CEventNumber],
		   temp.[TotalNumber]
	FROM (
		SELECT  ISNULL(abe.[UserID], ce.[UserID]) AS [UserID],
				ISNULL(abe.[DateTime], ce.[DateTime]) AS [DateTime],
				abe.[AEventNumber],
				abe.[BEventNumber],
				ce.[CEventNumber],
				ISNULL(abe.[AEventNumber], 0) + ISNULL(abe.[BEventNumber], 0) + ISNULL(ce.[CEventNumber], 0) as TotalNumber
		FROM
			(SELECT ISNULL(ae.[UserID], re.[UserID]) AS [UserID],
					ISNULL(ae.[DateTime], re.[DateTime]) AS [DateTime],
					ISNULL([AEventNumber], 0) AS [AEventNumber],
					ISNULL([BEventNumber], 0) AS [BEventNumber],
					ISNULL([AEventNumber], 0) + ISNULL([BEventNumber], 0) as TotalNumber
			FROM
				(SELECT a.[UserID],
						a.[DateTime],
						a.[Number] AS [AEventNumber]
				FROM AEvent AS a) AS ae
				FULL JOIN
				(SELECT b.[UserID],
						b.[DateTime],
						b.[Number] AS [BEventNumber]
				FROM BEvent AS b) AS re
				ON ae.[UserID] = re.[UserID] and ae.[DateTime] = re.[DateTime]) AS abe
			FULL JOIN
			(SELECT c.[UserID],
					c.[DateTime],
				    c.[Number] AS [CEventNumber]
				FROM CEvent AS c) AS te
			ON abe.[UserID] = ce.[UserID] and abe.[DateTime] = ce.[DateTime]
		) AS temp
```
当A表没有B内的用户编号或者统计时间时，使用B的代替，两张表先联接查询然后在和第三张表联接，否则A没有数据时，B的信息不能与C比较，导致B、C没有联接到一条内

### 小记
1. `ISNULL()`可以判断字段是否为空，并使用后面的值补全
2. 按天统计可以将转化为天的时间字段用于`GROUP BY`，可以使用`CONVERT(date, [dt])`转换，每天可以用`date`类型；`SQL Server`也可以使用`GROUP BY year([dt]), month([dt]), day([dt])`作为分组条件，实现按每天分组，可推出按年、按月分组；其他需求分组可以考虑使用字符串截取作为分组条件
