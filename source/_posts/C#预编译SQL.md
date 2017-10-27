---
title: 'C#预编译SQL'
date: 2017-10-27 14:34:18
tags:
---
C#中预编译SQL方法如下：
```c#
int System.Data.Entity.Database.ExecuteSqlCommand(string sql, params object[] parameters);
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

搜到的，还没使用过，记录一下
查询方法：
```c#
var db = new MSSqlDBContext();
var name = "tom";
var list = db.Set<Person>().FromSql($"select * from {nameof(Person)} where {nameof(name)}=@{nameof(name)} ", 
new SqlParameter(nameof(name), name)).ToList();
```
