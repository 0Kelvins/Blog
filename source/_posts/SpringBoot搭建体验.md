---
title: SpringBoot搭建体验
date: 2017-11-03 11:50:12
tags: [Java, Web, SpringBoot]
---

虽然现在不在用Java开发，但是决定了解一下Java Web开发在用的比较新的东西
在这记录一下，SpringBoot搭建一个小型项目框架

### 工具清单
JDK IDEA MySQL

### 框架工具组成
SpringBoot + Mybatis + Thymeleaf + Maven

### 搭建过程
1. 新建工程 -> 选择`Spring Initializr` -> 选好JDK -> 填好项目信息
2. 选择要集成的框架，这里选基本的`SpringBoot`项目需要的
     Web -> Web
     Template Engines -> Thymeleaf
     SQL -> MyBatis JDBC MySQL
3. IDEA搭建好基本框架，Maven添加依赖包
4. 删除`application.properties`，新建`application.yml`、`application-dev.yml`和`application-prod.yml`，分别作为主配置、开发配置、生成配置文件
`application.yml`:
```
    spring:
      thymeleaf:
        mode: HTML5
        encoding: utf-8
        content-type: text/html
        cache: false
      profiles:
        active: dev # 表示使用application-dev.yml
      datasource:
        driver-class-name: com.mysql.jdbc.Driver
        url: jdbc:mysql://127.0.0.1:3306/test?useUnicode=true&characterEncoding=utf8
        username: root
        password:
        tomcat:
          initialSize: 1
          min-idle: 1
          max-idle: 20
          max-wait: 60000
          timeBetweenEvictionRunsMillis: 60000
          minEvictableIdleTimeMillis: 30000
          validationQuery: SELECT 1
          testWhileIdle: true
          testOnBorrow: false
          testOnReturn: false
    logging:
      file: logs/demo.log
```
`application-dev.yml`:
```
    server:
      port: 8080
```
`application-prod.yml`:
```
    server:
      port: 443
      ssl:
        key-store: classpath:xxx.jks
        key-store-password: xxx
        keyStoreType: JKS
        keyAlias: xxx
```
5. 然后按照我的`SpringBootDemo`仓库来建controller什么的，就好了。
6. 好吧，前面好多别人写了很多遍的东西，需要的话看我参考的博客就好了。
`Thymeleaf`之前只撇过几眼，好像跟`JSTL`有点像，就没注意

`Thymeleaf`它是一个XML/XHTML/HTML5模板引擎，使用各种包含`th:*`属性的标签，格式其实和HTML有点不一样，head、body什么的都不一样。

Thymeleaf的url，因为模板里好像不能用`&`符号，需要`&amp;`替换，但是官方有对应的标签的
```html
<!-- <a href="/test?id=1&name=2">a</a> -->
<a th:href="@{/test(id=1, name=2)}">a</a>
```
7. 配置启动设置，添加`SpringBoot`启动配置，集成了Tomcat的，不用想`SpringMVC`等等以前的配置Tomcat的配置，`Main class`就是`XxxApplication`，选上`Use classpath of module`和`JRE`，就可以启动了。
8. 为了开发看起来舒服点，在`Project Structure`的`Modules`中设置一下对应文件目录作用，设置一下`Main class`为Spirng配置文件
