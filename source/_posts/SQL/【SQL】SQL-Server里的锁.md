---
title: 【SQL】SQL Server里的锁
comments: true
categories: SQL
tags:
  - lock
  - SQL
  - SQL Server
abbrlink: d1379167
date: 2017-12-12 10:43:07
---

记录一下 `SQL Server` 里的锁相关知识
<!-- more -->

### 参考

[SQL SERVER的锁机制](https://www.cnblogs.com/chillsrc/archive/2013/04/13/3018386.html)
[sql server锁知识及锁应用](http://blog.csdn.net/huwei2003/article/details/4047191)

## 锁类型

| 锁类型 | 说明 | 
| ------------- |:-------------:|
| 共享 (S) | 用于不更改或不更新数据的读取操作，如 SELECT 语句。 |
| 更新 (U) | 用于可更新的资源中。 防止当多个会话在读取、锁定以及随后可能进行的资源更新时发生常见形式的死锁。 |
| 独占(也可称排他)(X) | 用于数据修改操作，例如 INSERT、UPDATE 或 DELETE。 确保不会同时对同一资源进行多重更新。 |
| 意向 | 用于建立锁的层次结构。 意向锁包含三种类型：意向共享 (IS)、意向排他 (IX) 和意向排他共享 (SIX)。 |
| 架构 | 在执行依赖于表架构的操作时使用。 架构锁包含两种类型：架构修改 (Sch-M) 和架构稳定性 (Sch-S)。 |
| 大容量更新 (BU) | 在向表进行大容量数据复制且指定了 TABLOCK 提示时使用。 |
| 键范围 | 当使用可序列化事务隔离级别时保护查询读取的行的范围。 确保再次运行查询时其他事务无法插入符合可序列化事务的查询的行。 |

## 锁查询

* 查询目前锁的表
```sql
select request_session_id spid, OBJECT_NAME(resource_associated_entity_id) tablename, request_status, request_type, request_mode
    from sys.dm_tran_locks where resource_type='OBJECT'
```

* 查询目前死锁的进程
```sql
select spid, blocked, loginame, last_batch, status, cmd, hostname, program_name  
from sys.sysprocesses  
where spid in  
( select blocked from sys.sysprocesses where blocked <> 0 ) or (blocked <>0) 
```

* 查询锁信息
```sql
select req_spid  
,case req_status when 1 then '已授予' when 2 then '正在转换' when 3 then '正在等待' end as req_status  
,case rsc_type when 1 then 'NULL 资源（未使用）' when 2 then '数据库' when 3 then '文件'  
    when 4 then '索引' when 5 then '表' when 6 then '页' when 7 then '键'   
    when 8 then '扩展盘区' when 9 then 'RID（行 ID)' when 10 then '应用程序' else '' end rsc_type  
,coalesce(OBJECT_NAME(rsc_objid),db_name(rsc_dbid)) as [object]  
,case req_mode when 1 then 'NULL' when 1 then 'Sch-S' when 2 then 'Sch-M' when 3 then 'S'   
    when 4 then 'U' when 5 then 'X' when 6 then 'IS' when 7 then 'IU' when 8 then 'IX' when 9 then 'SIU'   
    when 10 then 'SIX' when 11 then 'UIX' when 12 then 'BU' when 13 then 'RangeS_S' when 14 then 'RangeS_U'   
    when 15 then 'RangeI_N' when 16 then 'RangeI_S' when 17 then 'RangeI_U' when 18 then 'RangeI_X'   
    when 19 then 'RangeX_S' when 20 then 'RangeX_U' when 21 then 'RangeX_X' else '' end req_mode  
,rsc_indid as index_id,rsc_text,req_refcnt  
,case req_ownertype when 1 then '事务' when 2 then '游标' when 3 then '会话' when 4 then 'ExSession' else'' end req_ownertype  
from sys.syslockinfo WHERE rsc_type<>2 ;
```