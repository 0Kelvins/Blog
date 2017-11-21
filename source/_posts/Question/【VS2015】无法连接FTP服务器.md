---
title: 【VS2015】无法连接FTP服务器
comments: true
categories: Tools
tags:
  - 随笔
  - Tools
abbrlink: 60b740d3
date: 2017-11-20 13:37:36
---

使用 Visual Studio 2015 时出现的问题

环境：win7

### 场景
* 发布Web项目到FTP时 失败，并提示 _无法打开网站"ftp://..."。未安装与 FTP 服务器进行通信所需的组件（或"Unable to open the Web site 'ftp://...'. The components for communicating with FTP servers are not installed."）*_
* 可以直接使用文件管理器正常访问`ftp`地址

### 参考
* [The components for communicating with FTP servers are not installed.——
paaccess](https://social.msdn.microsoft.com/Forums/en-us/338f95b6-19a3-48da-a975-662b4cb1e86c/the-components-for-communicating-with-ftp-servers-are-not-installed?forum=visualstudiogeneral)
* [Publish with FTP does not work —— kurtdevocht](https://github.com/aspnet/Tooling/issues/748)

### 解决方法
安装**32位**的 `Visual C++ Redistributable Packages for Visual Studio 2013` ，然后重启电脑即可

下载链接：[vcredist_x86](https://download.microsoft.com/download/F/3/5/F3500770-8A08-488E-94B6-17A1E1DD526F/vcredist_x86.exe)

### 记
考虑把问题翻译成英文以后查，的确能搜到更多的信息