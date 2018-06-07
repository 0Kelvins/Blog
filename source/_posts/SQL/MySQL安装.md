---
title: MySQL安装
categories: SQL
tags: 
 - MySQL
 - SQL
abbrlink: 8b39915a
date: 2017-11-02 20:43:13
---

0. 去[官网](https://dev.mysql.com/downloads/mysql/) -> Other Downloads:Windows (x86, 64-bit), ZIP Archive -> 下载mysql社区版压缩包

1. 解压到要安装的目录，如：``D:\Program Files\mysql-8.0.11-winx64``

2. 在根目录下新建``my.ini``，如下：

   ```yml
    [mysql]
    # 设置mysql客户端默认字符集
    default-character-set=utf8

    [mysqld]
    # 设置3306端口
    port = 3306
    # 设置mysql的安装目录
    basedir="D:\Program Files\mysql-5.7.20-winx64"
    # 设置mysql数据库的数据的存放目录
    datadir="D:\Program Files\mysql-5.7.20-winx64\data"
    # 允许最大连接数
    max_connections=200
    # 服务端使用的字符集默认为8比特编码的latin1字符集
    character-set-server=utf8
    # 创建新表时将使用的默认存储引擎
    default-storage-engine=INNODB
    # sql规则
    sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'
   ```

3. cmd，cd进入``D:\Program Files\mysql-8.0.11-winx64\bin``目录，执行以下命令：

   ```shell
   > mysqld install
   Service successfully installed.
   > mysqld --initialize-insecure --user=mysql

   > net start mysql
    MySQL 服务正在启动 .
    MySQL 服务已经启动成功。
   ```

   这时候MySQL已经启动了，端口什么的如``my.ini``配置

4. 但是为了全局使用，需要在环境变量``Path``添加``D:\Program Files\mysql-8.0.11-winx64\bin``

（一开始下了个``mysql-8.0.11-winx64.zip``，还以为是msi文件压缩了一下呢。- -||
