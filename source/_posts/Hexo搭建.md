---
title: Hexo搭建
date: 2017-10-24 11:22:07
tags: hexo
---

### 教程
http://blog.csdn.net/gdutxiaoxu/article/details/53576018

### yilia主题地址链接
https://github.com/litten/hexo-theme-yilia.git

### hexo配置
http://blog.csdn.net/xuezhisdc/article/details/53130383

新建文章
``` bash
hexo new post "article title"
```
生成部署
``` bash
hexo g   # 生成
hexo d   # 部署
# 或直接
hexo d -g #在部署前先生成
```
部署即将生成在public文件夹内的文件复制到deploy.git内后，自动更新到git
自动部署需要安装插件，并配置发布地址等
