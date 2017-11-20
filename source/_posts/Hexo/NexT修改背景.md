---
title: NexT修改背景
comments: true
categories: 随笔
tags:
  - hexo
  - 随笔
abbrlink: 4daf947
date: 2017-11-20 18:21:17
---

## 修改背景步骤
* 添加背景图片，到路径`next->source->images`
* 修改NexT自定义样式文件：`next->source->css->_custom->custom.styl`
* 添加样式代码
```css
body {
    background-image: url("/images/background.png");
    background-attachment: fixed; /*不随页面移动*/
    background-repeat: no-repeat; /*不重复*/
    background-position: 50% 50%; /*居中*/
    background-size:cover;
}
/*内容半透明背景*/
.header-inner,
.content-wrap {
  background:rgba(255,255,255,0.75) !important;
}
/*底部连接颜色*/
#footer a {
    color:#eee;
}
```