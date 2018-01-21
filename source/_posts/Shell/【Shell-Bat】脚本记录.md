---
title: 【Shell/Bat】脚本记录
comments: true
categories: Shell
tags: Shell
abbrlink: e372f2fe
date: 2018-01-21 19:54:30
---
### 注释
shell里可以使用`#`号，bat里可以使用`rem`、`::`，还有很多其他注释的方法

### 变量
1. shell 变量定义与重定义
```sh
# 定义变量
$ var="变量"
$ echo $var
变量
$ var="重定义变量"
$ echo $var
重定义变量

# 输入变量
read -p "是否更新Blog(y/n) :" updateOp
```

2. bat 变量定义与重定义
```dos
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
1. shell的条件语句
```sh
# 输入变量
read -p "输入var:" var
# 判断变量是否等于 y （x为了避免比变量为空异常）
if [ "$var"x = "y"x ]; then
    echo "if内"
else
    echo "else内"
fi
```

2. bat的条件语句
```dos
REM /p 从输入赋值变量
set /p updateOp="是否更新（y/n）："
REM 判断输入（Y/N），/i 忽略大小写
if /i "%updateOp%"=="y" (
git pull origin master
)
```

### 记录
1. 注意空格的使用，脚本里空格往往是分隔命令和参数的，不像Java什么的里面可以用很多空格来分隔变量和运算符，让代码看起来更清晰。
2. 脚本如果写的不对，经常没有异常代码什么的，所以要仔细看输出，自己也多写点echo，好辨别执行情况

### 后言
1. 这里只记录了一些我自己想记的东西哦
2. 记得当初上Linux的时候，我还自己安装Ubuntu练习使用了一阵子的命令行，这门课成绩也还行，只是考完试以后就没怎么碰过了，后来就自己折腾centos的时候用过一点，然后就是开始用github以后了，最近弄点小脚本来给自己省点事，顺便记录一些