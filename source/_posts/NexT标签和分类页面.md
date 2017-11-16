---
title: NexT标签和分类页面
tags:
  - hexo
  - Next
abbrlink: 17076
date: 2017-11-06 22:14:22
---

## 步骤一
新建一个页面，命名为 tags 。命令如下：
```
$ hexo new page "tags"
```

## 步骤二
编辑刚新建的页面，将页面的类型设置为 tags ，主题将自动为这个页面显示标签云。页面内容如下：
```
title: tags
date: 2017-11-6 22:19:52
type: "tags"
---
```
注意：如果有启用多说 或者 Disqus 评论，默认页面也会带有评论。需要关闭的话，请添加字段 comments 并将值设置为 false，如：
```
title: tags
date: 2017-11-6 22:19:52
type: "tags"
comments: false
---
```
## 步骤三
在菜单中添加链接。编辑NexT的配置文件 ，添加 tags 到 menu 中，如下:
```
menu:
  home: / || home
  about: /about/ || user
  tags: /tags/ || tags
  categories: /categories/ || th
  archives: /archives/ || archive
```

## 添加 分类 categories
```
$ hexo new page "categories"
```
```
---
title: categories
date: 2017-11-06 22:07:29
type: "categories"
comments: false
---
```

## 备注
如果页面显示不正常，一般都是有地方拼写错了，或者需要清理浏览器缓存
