---
title: 【Js】使用小记
comments: true
categories: Front
tags:
  - Javascript
abbrlink: ae10444e
date: 2018-02-01 09:37:18
---
记一下`Js`的一些知识点

### `==`和`===`的区别
`==`是值相等比较（会做类型转换后比较），`===`是严格相等比较（还要比较类型）

1. 对于 `string` ，`number` 等基础类型， `==` 和 `===` 是有区别的
    1. 不同类型间比较，`==`之比较“转化成同一类型后的值”看“值”是否相等，`===` 如果类型不同，其结果就是不等
    2. 同类型比较，直接进行“值”比较，两者结果一样
2. 对于 `Array` ， `Object` 等高级类型， `==` 和 `===` 是没有区别的进行“指针地址”比较
3. 基础类型与高级类型， `==` 和 `===` 是有区别的
    1. 对于 `==` ，将高级转化为基础类型，进行“值”比较
    2. 因为类型不同， `===` 结果为 `false`

我的一篇随笔里有记过一个例子，这里再放一下
```js
0 == '' -> true
0 === '' -> false
```

### 没有块级作用域
```js
var data = '';
function test(data) {
    if (data != null) {
        var tips = 'data not null';
        console.log(tips);
    }
    else {
        var tips = 'data is null';
        console.log(tips);
    }
}
test(data);
```
上面的代码浏览器可以运行的，但是Js语法检查的话会报错吧，`tips` 变量在 `test()` 内被定义在两个代码块内，但是js没有块级作用域，函数作为Js内的最小作用域，所以 `tips` 变量这里重复定义了。

记：Js中没有用 `var` 声明的变量都是全局变量，而且是顶层对象的属性