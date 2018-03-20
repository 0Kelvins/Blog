---
title: 【SQL Server】发布订阅配置失败处理方法
comments: true
categories: SQL-Server
tags: SQL-Server
abbrlink: ce23289f
date: 2018-03-20 18:55:10
---
### 前言
因为业务需求，需要“实时”的同步基础平台的一些信息，公司使用的又是 `SQL Server` ，简单稳定起见，选择使用 **发布订阅** 功能来实现数据的同步。

### 环境
OS：Windows Server 2008 R2

DB：SQL Server 2008 R2

### 参考
[Sql Server 2008R2 数据库发布与订阅——DBArtist，博客园](https://www.cnblogs.com/DBArtist/p/5803271.html)

### 配置失败处理
* 发布服务器，删除本地发布失败：
    ```sql
    sp_removedbreplication 'DBName'  -- 强制删除被发布数据库的所有发布
    ```
* `订阅服务器连接根目录` -> `复制` -> `本地订阅` 内没有新建的订阅的情况下，删除多余的订阅服务器：
    ```sql
    sp_helpserver -- 查看服务器
    sp_dropserver '[name]', 'droplogins' -- 删除服务器
    ```
* `SQL Server代理` 重启，这个估计改名字的时候就要重启，不然会有报错

### 主要流程
1. 确认数据库的服务名和服务器的机器名一致
    ```sql
    -- 检查SQL Server 的服务器名称
    use master
    go
    select @@servername
    select serverproperty('servername')

    -- 删除所有之前配置的publishers
    select * from msdb.dbo.MSdistpublishers
    DELETE FROM msdb.dbo.MSdistpublishers
    select * from msdb.dbo.MSdistpublishers
    exec sp_droplinkedsrvlogin 'old_server_name',null
    exec sp_dropserver 'old_server_name', 'droplogins'

    -- 配置计算机名与服务名一致
    USE master
    GO
    if serverproperty('servername') <> @@servername  
    begin  
        declare @server sysname  
        set   @server = @@servername  
        exec sp_dropserver @server = @server  
        set   @server = cast(serverproperty('servername') as sysname)  
        exec sp_addserver @server = @server , @local = 'LOCAL'  
    end
    ```
    **重启SQL Server服务、SQL Server代理服务**

    然后 `sp_helpserver` 可以查看到当前的服务器名称，没有配置过应该只有 `dbv32` 和一个当前机器名一样的服务器，

2. 配置别名
    
    打开发布服务器和订阅服务器的 `SQL Server 配置管理器` 在 **[SQL Native Client 10.0配置(32位)]** 和 **[SQL Native Client 10.0配置]** 中配置别名

    > 别名：[第一步确认的机器名]
    >
    > 端口号：1433
    >
    > 服务器：对应的服务器机器的IP地址
    >
    > 协议：TCP/IP

    **发布服务器需要配置自己和所有订阅服务器的别名，订阅服务器需要配置自己和发布服务器的别名**

3. 发布服务器建立发布
    * `发布服务器连接根目录` -> `复制` -> `本地发布`
    * 右键 `新建发布`，然后根据提示选择性Next
    * 不行了看一下配置一下 `安全设置` ，上面选第二个 `在SQL Server 代理账户下运行`，然后下面选第二个配置 `SQL Server 登录名`
    * 然后Next到完成，没报错就搞定了


4. 订阅服务器建立订阅
    * `订阅服务器连接根目录` -> `复制` -> `本地订阅`
    * 右键 `新建订阅`，发布服务器选择：查找，添加你的发布服务器，用之前配的别名
    * 需要实时同步的话，分发代理位置选第一个，在发布服务器上运行分发服务，发布服务器主动推送。根据需要也可以选第二个
    * 订阅服务器和数据库，数据库可以点下拉然后拉到最上面自己新建
    * 分发服务器安全连接，配置之前 `发布服务器` 的 `安全设置`
    * 然后根据提示选择性Next到完成，没报错就搞定了所有配置


5. 右键发布服务器的发布， `启动复制监视器` ，查看状态，没报错，然后快照完成，在订阅看到数据就可以了

### 后记
一开始配置不知道哪里出问题了，快照不生成，快照代理启动就挂掉，订阅服务器的数据库也没看到数据，发布也不给删，报错发布下面还有订阅

就找了半天删除的方法，后来发布订阅的服务器删干净， `SQL Server代理` 重启，重新配置了一遍就好了，也是心累╮(╯_╰)╭

现在想想估计是代理服务没有重启导致的。总之，以后配置的话，记着顺手把这个也重启了吧。