---
title: 添加虚拟环境到jupyter的kernel
comments: true
tags:
  - 随笔
  - Tools
  - python
abbrlink: 485b26f6
date: 2020-10-11 17:07:18
categories:
---

## 问题
使用conda创建的虚拟环境，使用pycharm在该环境下启动jupyter无法检测到GPU
<!-- more -->

## 解决办法
添加虚拟环境到jupyter的kernel

1.使用conda install ipykernel安装ipykernel包
```sh
conda install ipykernel
```

2.此步骤非常重要，使用ipython kernel install --user --name=tensorflow （tensorflow为你虚拟环境名称），添加虚拟环境kernel
```sh
python -m ipykernel install --user --name=tensorflow
```

3.再次打开jupyter就可以看到虚拟环境变量配置好了，可以切换kernel
```python
import tensorflow as tf
print(tf.config.list_physical_devices('GPU'))
```
可以看到自己的GPU了！