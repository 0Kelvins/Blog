---
title: Hexo搭建
tags: hexo
abbrlink: 57ee7c1d
date: 2017-10-24 11:22:07
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

### 记录
1. __部署__：将生成在public文件夹内的文件复制到deploy.git内后，自动推送到git，自动部署需要安装插件，并配置发布地址等

2. 新建文章的 __命名、分类、标签__：不能包含``#``符号，Github上面会404，其他的``\/.?``之类的应该也不行，``-_``以及数字是可以的

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

4. `_post`文件夹下是可以新建自己的文件夹的

### [hexo标签插件](https://hexo.io/zh-cn/docs/tag-plugins.html)
__jsFiddle__
在文章中嵌入 jsFiddle。
```
{% jsfiddle shorttag [tabs] [skin] [width] [height] %}
```
__Gist__
在文章中嵌入 Gist。
```
{% gist gist_id [filename] %}
```
__iframe__
在文章中插入 iframe。
```
{% iframe url [width] [height] %}
```
__Image__
在文章中插入指定大小的图片。
```
{% img [class names] /path/to/image [width] [height] [title text [alt text]] %}
```
__Link__
在文章中插入链接，并自动给外部链接添加 target="_blank" 属性。
```
{% link text url [external] [title] %}
```