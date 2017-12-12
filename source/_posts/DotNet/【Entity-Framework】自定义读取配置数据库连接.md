---
title: 【Entity Framework】自定义读取配置数据库连接
comments: true
categories: CSharp
tags:
  - CSharp
  - DotNet
  - Entity Framework
abbrlink: 2508d3d8
date: 2017-12-01 15:23:15
---

## 问题
打包的人反馈`EF DBFirst`的数据库连接配置里面的`&quot`(“`"`”)，处理不好，沟通起来又不在一个地方，很麻烦，连接配置也的确不太好看，于是搜了下，看到了可以自定义。

## 版本
Entity Framework v6.1.3

## 解决方法
1. 写个获取连接的类
```cs
using System.Configuration;

namespace Utils
{
    public class EFConfig
    {
        public static string DataBaseConnectionString()
        {
            string DataBaseConnection = ConfigurationManager.AppSettings["Connection"].ToString();
            return ConnectionString(DataBaseConnection);
        }

        public static string ConnectionString(string DataBaseConnection)
        {
            return "metadata=res://*/EFData.csdl|res://*/EFData.ssdl|res://*/EFData.msl;provider=System.Data.SqlClient;provider connection string =\""
                    + DataBaseConnection + "persist security info=True;multipleactiveresultsets=True;application name=EntityFramework\"";
        }
    }
}

```
2. 重写一下`edmx`->`*.Context.tt`->`*.Context.cs`的构造函数，可以直接修改`*.Context.tt`文件内的模板，避免下次更新数据库时，代码需要重新修改，搜索`base`即可，修改后面的`"name=xxx"`为你获取自定义连接的方法。
```cs
public EFDbContext()
    : base(Utils.EFConfig.DataBaseConnectionString())
{
}
```


3. 在`Web.config`的`<appSettings>`节点配置，删除不使用了的`<connectionStrings>`节点
```xml
<appSettings>
    <add key="Connection" value="data source=127.0.0.1;initial catalog=DBName;user id=User;password=Pwd;" />
</appSettings>
```

## 小结
其实这主要是构造函数本来的方法就支持直接配置连接字符串

![EF的构造函数](/assets/images/ef_connect_string/ef-construct.png)
