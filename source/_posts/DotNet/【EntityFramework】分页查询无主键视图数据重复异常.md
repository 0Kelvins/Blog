---
title: 【EntityFramework】分页查询无主键视图数据重复异常
comments: true
categories: DotNet
tags:
  - CSharp
  - DotNet
  - Entity Framework
abbrlink: 78ebec87
date: 2018-01-17 14:57:42
---

### 问题
在做[统计的查询视图](https://0kelvins.github.io/post/41b37696.html)之后，发现EF查询的结果第一条覆盖了第二条，两条数据只有一个时间字段不一样

### 原因分析
EF默认有缓存，视图没有建立主键，EF的缓存机制认为这两条除了时间不同的数据一致，就没有再从数据库取，然后出现`SQL Server Profiler`里面的SQL正常，但是拿到的数据死活都不对。

### 解决方法
对视图使用`.AsNoTracking()`，取消EF对这个视图的缓存（然后可以使用`Entity Framework Plus`调用`MemoryCache`或`Redis`来做缓存）
```cs
var l = from s in statView.AsNoTracking()
        select s;
```