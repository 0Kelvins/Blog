---
title: Maven多模块项目搭建
tags:
  - Maven
  - Java
  - 随笔
abbrlink: 1ddf75e3
date: 2017-11-06 16:58:12
---

__框架/工具 关键字__
> Maven SpringBoot Myatis MySQL Tomcat IDEA

### 部分操作
1. 新建父工程，`New > Project > Maven`，不使用原型（不勾选`Create from archetype`） -> 填写项目信息
2. 删除父工程下`src`目录
3. 右键项目，新建子模块（New -> Module），填写项目名称，其他默认即可
   |-> 非web模块，不使用原型新建`Maven`模块
   |-> web模块
     |-> 使用`maven-archetype-webapp`构建
     |-> `Spring Initializr`构建`Spring`相关项目
新建模块：
![新建模块](/assets/images/multi_module_demo/new-module.png)
简单MVC项目结构如下所示：
![项目结构](/assets/images/multi_module_demo/project-struct.png)

4. 在各个子模块的pom文件中添加互相的依赖（父工程在前一步自动添加了对应的子模块`<modules>`）
![模块依赖](/assets/images/multi_module_demo/module-dependencies.png)

5. 添加依赖到父工程的pom中（`Spring Initializr`构建web模块的，把web模块的pom依赖改到父工程
然后，父工程pom添加
```xml
<build>
    <plugins>
        <plugin>
            <!-- The plugin rewrites your manifest -->
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <version>1.5.8.RELEASE</version>
            <configuration><!-- 指定该Main Class为全局的唯一入口 -->
                <mainClass>com.like.DemoWebApplication</mainClass>
                <layout>ZIP</layout>
            </configuration>
            <executions>
                <execution>
                    <goals>
                        <goal>repackage</goal><!--可以把依赖的包都打包到生成的Jar包中-->
                    </goals>
                    <!--可以生成不含依赖包的不可执行Jar包-->
                    <!-- configuration>
                      <classifier>exec</classifier>
                    </configuration> -->
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```
web模块pom添加
```xml
<build>
    <!-- 为jar包取名 -->
    <finalName>demo-start</finalName>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <configuration>
                <skipTests>true</skipTests>
            </configuration>
        </plugin>
    </plugins>
</build>
```
6. 右键父项目 > `Open Module Settings`进入`Project Structure` > 子模块 > `Dependencies` > `+` > `Module Dependency`，添加子模块需要引用的其他子模块
7. maven打包
8. 配置启动设置，配置为启动web子模块的配置即可
![模块依赖](/assets/images/multi_module_demo/run-config.png)

### 记录
1. maven统一打包命令(跳过测试)
    ```
    mvn package —Dmaven.test.skip=true
    ```

2. 编译/打包报错程序包xxx.xxx.xxx不存在，尝试
    ```
    mvn clean
    ```

3. 子模块间的引用要写在各自的pom文件里的 `<dependencies>`中，父工程配置`<modules>`即可

4. 引用的jar包写在父工程pom的 `<dependencies>`中
