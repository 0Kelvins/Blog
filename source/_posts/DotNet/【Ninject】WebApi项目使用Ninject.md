---
title: 【Ninject】WebApi项目使用Ninject
comments: true
categories: DotNet
tags:
  - DotNet
  - Ninject
  - WebApi
abbrlink: 1201e0f4
date: 2017-12-18 18:56:28
---

WebApi项目的依赖注入需要使用`System.Web.Http.Dependencies`里的`IDependencyResolver`来实现，和Mvc的`IDependencyResolver`是不一样的，所以需要实现的`Resolver`不一样。虽然了解了大概怎么写，但是始终没能让自己重写的`Resolver`启动，并且看别人写好的还解决了其他的一些注入问题。于是，决定还是用`Ninject`下面fork的[remogloor/Ninject.Web.WebApi](https://github.com/ninject/Ninject.Web.WebApi)，免得浪费时间折腾轮子了。

[Mvc的配置](http://www.cnblogs.com/Locked-J/p/7722864.html)

### 环境
`WebApi2`、`.Net Framework 4.5`、`VS2015`

### 使用方法
1. 添加引用，使用NuGet安装以下两个包
* Ninject
* Ninject.Web.WebApi

查看引用会发现附赠了 `Ninject.Web.Common`、`Ninject.Web.Common.WebHost`、`Ninject.Web.WebApi.WebHost` 三个包。

2. 然后修改在App_Start下`NinjectWebCommon`的`RegisterServices()`，在里面后面加上自己的注入bind，如：
```cs
private static void RegisterServices(IKernel kernel)
{
    kernel.Load(Assembly.GetExecutingAssembly());
    kernel.Bind<IUserRepository>().To<UserRepository>();
}
```

以上。使用起来很简单。就是封了一层，有些东西需要自己看源码理解了。