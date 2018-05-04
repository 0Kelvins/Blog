---
title: 【SQL】GROUP BY分组统计
comments: true
categories: SQL
tags: SQL
abbrlink: ef45c8bd
date: 2018-05-04 11:12:25
---

### 问题

有一张学生表，包含学生、班级、性别（男、女）等信息，要求查询出全是男生或全是女生的班级

### 分组统计

一般要查询的字段不是表格的主要信息的时候，需要按照需要的字段分组。如在学生表查班级信息。

当需要根据分组后的数据统计筛选时，需要使用 `HAVING` 来进行

```sql
SELECT ClassID
FROM Students
GROUP BY ClassID
HAVING COUNT(DISTINCT Gender) = 1
```

### 记

好久没写过什么复杂查询了，看到这个问题，一时还没想对，如果使用 `GROUP BY ClassID, Gender` 进行分组的话，会最终以 **班级 * 性别** 的分组返回

| ClassID | Gender | COUNT(Gender) |
| - | - | - |
| class01 | 男 | 12 |
| class01 | 女 | 20 |
| …… |

这样就无法对性别进行筛选了，所以分组时要注意分组统计的条件，是否应该加入分组