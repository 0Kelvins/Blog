---
title: 【Jmeter】4.0的安装
comments: true
categories: 测试
tags:
  - Jemeter
  - 测试
abbrlink: a1d9e130
date: 2018-07-02 08:50:11
---
### 简述
Jmeter4.0与前面的版本有所不一样，所有的插件由新的插件管理器下载，收集服务器性能信息的包也有点难找，远程脚本调试的配置也有点小坑

### 过程
1. [官网](https://jmeter.apache.org/)下载，解压到自己的目录（最好没空格的路径），将bin目录添加至环境变量（可选）

2. 修改配置文件 `jmeter.properties` ，搜索配置项进行修改

```yml
language=zh_CN # 默认UI语言
remote_hosts=172.16.41.34:1099 # 一定是正在运行的所有服务，如果有没启动的服务会报错，坑。
server_port=1099 # RMI通信端口，被远程的服务器需要换端口改这个

#server.rmi.localport=1089 # 服务器端用于指定本地端口，默认随机可用端口，不是上面remote的端口！
```

3. 插件安装：https://jmeter-plugins.org/downloads/all/
    > Download plugins-manager.jar and put it into lib/ext directory, then restart JMeter. 

    3.1 将下载的 `plugins-manager.jar` 放到jmeter的 `lib/ext` 目录下，重启后

    3.2 选项->Plugins Manager->Available Plugins->PerfMon (Servers Performance Monitoring)(勾选)->Apply...


4. 安装PerfMon服务器端客户端，根据插件说明文档：https://jmeter-plugins.org/wiki/PerfMon/

    > ## Installation
    > Server Agent tool detailed description is placed [here](https://github.com/undera/perfmon-agent/blob/master/README.md).

    找到服务器收集性能数据的包 `Server Agent`，下载并安装到服务器

5. 服务器端安装jmeter，用于远程脚本执行，配置注意 `server_port` 要于你客户端配置的 `remote_hosts` 里一样，客户端要注意如果出现
    > java.rmi.ConnectException: Connection refused to host: (your server ip); nested exception is: 
    > java.net.ConnectException: Connection timed out: connect

    那么你的 `remote_hosts` 配置中的一个服务器端jmeter可能没有启动

### 记
搭环境什么的最坑了Orz。