---
title: Hexo搭建
date: 2017-10-24 11:22:07
tags: hexo
---

### 教程
http://blog.csdn.net/gdutxiaoxu/article/details/53576018

### 主题github地址
__yilia__ `https://github.com/litten/hexo-theme-yilia.git`
__NexT__ `https://github.com/iissnan/hexo-theme-next.git`

### hexo配置
http://blog.csdn.net/xuezhisdc/article/details/53130383

新建文章
```bash
hexo new post "article title"
```
生成部署
```bash
hexo g   # 生成
hexo d   # 部署
# 或直接
hexo d -g # 在部署前先生成
```

### 说明
1. __部署__：将生成在public文件夹内的文件复制到deploy.git内后，自动推送到git，自动部署需要安装插件，并配置发布地址等

2. 新建文章的 __命名__：不能包含``#``符号，Github上面会404，其他的``\/.?``之类的应该也不行``-_``以及数字是可以的

3. 自定义页面，不渲染
[hexo跳过指定文件的渲染](http://e12e.com/2016/06/05/hexo跳过指定文件的渲染/)
在`_config.yml`文件中设置`skip_render`，都是相对`source`目录的路径：
* 跳过`source`目录下的`test.html`:
```skip_render: test.html```
* 跳过`source`目录下`test`文件夹内所有文件：
```skip_render: test/*```
* 跳过source目录下`test `文件夹内所有文件包括子文件夹以及子文件夹内的文件：
```skip_render: test/**```
* 跳过多个路径：
```
skip_render:
 - test.html
 - test/*
```