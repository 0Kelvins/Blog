---
title: '【C#】预编译SQL'
categories: CSharp
tags:
  - SQL
  - 随笔
  - CSharp
abbrlink: 9dae95bf
date: 2017-10-27 14:34:18
---
C#中预编译SQL方法如下：
```c#
// System.Data.Entity.Database
int ExecuteSqlCommand(string sql, params object[] parameters);
```

使用EF6框架，仓库使用生成的数据库上下文：
```c#
private EFDbContext dbctx = new EFDbContext();
```
使用示例：
```c#
// 删除tableA中，name以"$"结尾的数据
string sql = "DELETE FROM tableA WHRER name like \"%@sign\"";
int result = dbctx.Database.ExecuteSqlCommand(sql,
               new SqlParameter("sign", "$")
             );
```

查询方法，如下：
```c#
var db = new MSSqlDBContext();
var name = "tom";
var list = db.Set<Person>().FromSql($"select * from {nameof(Person)} where {nameof(name)}=@{nameof(name)} ", 
new SqlParameter(nameof(name), name)).ToList();
```
