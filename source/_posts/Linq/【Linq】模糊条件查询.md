---
title: 【Linq】模糊条件查询
comments: true
categories: Linq
tags:
  - Linq
  - SQL
abbrlink: 10424fa
date: 2018-01-25 20:08:39
---
### 模糊查询
SQL里字段的模糊匹配可以使用`like`关键字，使用方式如：`like "%search"`、`like "search%"`、`like "%search%"`，分别对应后缀、前缀、包含三种模糊匹配方式

### Linq对应的模糊查询
1. 前缀匹配搜索
```cs
var l = from p in Person
        where p.name.StartsWith("jack")
        select p;
```

2. 后缀匹配搜索
```cs
var l = from p in Person
        where p.name.EndsWith("chen")
        select p;
```

3. 包含匹配搜索
```cs
var l = from p in Person
        where p.name.Contains("ac")
        select p;
```

4. 条件模糊查询

有时候界面上面，我们在表格前面会有个输入框，提供一些字段的搜索，在不输入的时候，这个搜索条件就不作为限制条件

而这时传到后端的条件是`null`，前面三种搜索直接使用的话，会出现结果的错误，`null`成了限制条件

所以需要在`where`里加上对应字段为`null`的情况，使搜索条件为空时，模糊匹配失效
```cs
string search = null;

var l = from p in Person
        where p.name.Contains(search) || search == null
        select p;
```

5. 条件中`in`与`not in`
参考：[LINQ - 在Where條件式中使用in與not in —— ADOU-V，博客园](https://www.cnblogs.com/a-dou/p/5916895.html)

`in`的SQL实现：
```sql
Select ProductID, ProductName, CategoryID From dbo.Products  
Where CategoryID in (1, 2)
```

`in`的Linq实现：
```cs
var l = from p in dbctx.Products 
        where (new int?[] {1, 2}).Contains(p.CategoryID) 
        select p;
```

`not in`的SQL实现：
```sql
Select ProductID, ProductName, CategoryID From dbo.Products  
Where CategoryID not in (1, 2)
```

`not in`的Linq实现：
```cs
var l = from p in dbctx.Products 
        where !(new int?[] {1, 2}).Contains(p.CategoryID) 
        select p;
```