---
title: 【Shell/Bat】脚本记录
comments: true
date: 2018-01-21 19:54:30
categories: Shell
tags: Shell
---
### 注释
shell里可以使用`#`号，bat里可以使用`rem`、`::`，还有很多其他注释的方法

### 变量
```sh
# shell 
# 变量定义与重定义
$ var="变量"
$ echo $var
变量
$ var="重定义变量"
$ echo $var
重定义变量

# 输入变量
read -p "是否更新Blog(y/n) :" updateOp
```

```sh
:: bat 变量定义与重定义
REM 定义变量
set var=变量
echo %var%
变量
set var=重定义变量
echo %var%
重定义变量

REM 输入变量
set /p updateOp = "是否更新（y/n）："

```


### if...else...
```sh
# shell的条件语句，判断变量是否等于 y （x为了避免比变量为空异常）
if [ "$updateOp"x = "y"x ]; then
    echo "if内"
else
    echo "else内"
fi
```

### 记录
1. 注意空格的使用，脚本里空格往往是分隔命令和参数的，不像Java什么的里面可以用很多空格来分隔变量和运算符，让代码看起来更清晰。
2. 待续

### 后言
1. 这里只记录了一些我自己想记的东西哦
2. 记得当初上Linux的时候，我还自己安装Ubuntu练习使用了一阵子的命令行，这门课成绩也还行，只是考完试以后就没怎么碰过了，后来就自己折腾centos的时候用过一点，然后就是开始用github以后了，最近弄点小脚本来给自己省点事，顺便记录一些