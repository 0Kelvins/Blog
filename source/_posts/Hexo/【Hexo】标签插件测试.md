---
title: 【Hexo】标签插件测试
comments: true
categories: 随笔
tags:
  - hexo
  - 标签插件
abbrlink: 225108ff
date: 2017-11-20 16:02:23
---

主要是可以自定义一些样式
## Hexo标签插件
### 图片

在文章中插入指定大小的图片。
```html
{% img [class names] /path/to/image [width] [height] [title text [alt text]] %}

<!-- 例 -->
{% img img-test /assets/images/avatar/avatar.jpg 150 150 图片测试 %}
```
{% img img-test /assets/images/avatar/avatar.jpg 150 150 图片测试 %}


## NexT内建标签
### 引用块
```html
<!-- HTML方式: 直接在 Markdown 文件中编写 HTML 来调用 -->
<!-- 其中 class="blockquote-center" 是必须的 -->
<blockquote class="blockquote-center">blah blah blah</blockquote>

<!-- 标签 方式，要求版本在0.4.5或以上 -->
{% centerquote %}blah blah blah{% endcenterquote %}

<!-- 标签别名 -->
{% cq %} blah blah blah {% endcq %}
```
{% cq %} blah blah blah {% endcq %}

### 突破容器宽度限制的图片
```html
<!-- HTML方式: 直接在 Markdown 文件中编写 HTML 来调用 -->
<!-- 其中 class="full-image" 是必须的 -->
<img src="/image-url" class="full-image" />

<!-- 标签 方式，要求版本在0.4.5或以上 -->
{% fullimage /image-url, alt, title %}

<!-- 别名 -->
{% fi /image-url, alt, title %}
```
```
// 图片太大没有cdn，先注释了=_=
{% fi /assets/images/illustration/HallstattAustria.jpg, NexT内建标签fi, NexT内建标签fi %}
```

### Bootstrap Callout
```html
{% note class-name %} Content (md partial supported) {% endnote %}

<!-- 例 -->
{% note success %} 内容 **加粗** (md partial supported) {% endnote %}
```
可选`class-name`为Bootstrap的样式:
`default`、`primary`、`success`、`info`、`warning`、`danger`

{% note default %} 内容 **加粗** {% endnote %}
{% note primary %} 内容 **加粗** {% endnote %}
{% note success %} 内容 **加粗** {% endnote %}
{% note info %} 内容 **加粗** {% endnote %}
{% note warning %} 内容 **加粗** {% endnote %}
{% note danger %} 内容 **加粗** {% endnote %}