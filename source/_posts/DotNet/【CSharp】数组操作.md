---
title: 【CSharp】数组操作
comments: true
categories: CSharp
tags:
  - 随笔
  - CSharp
abbrlink: 43a178cc
date: 2017-11-27 16:08:37
---

### 前言
数组的合并拆分，基本就是利用数组的复制方法来实现

C#里面使用`lambda`表达式很方便，数组的各种操作使用`lambda`就很简洁，但是效率也是自然不如其他的函数了

## 数组合并(复制)
```c#
int[] a = new int[] { 1, 2, 3, 4, 5 };
int[] b = new int[] { 6, 7, 8, 9 };
int[] c = new int[](a.Length + b.Length);

// lambda表达式 Concat 方法
int[] c = a.Concat(b).ToArray();

/* Array.Copy 支持所有类型数组，支持装拆箱
public static void Copy(
	Array sourceArray,
	int sourceIndex,
	Array destinationArray,
	int destinationIndex,
	int length
)
*/
Array.Copy(a, 0, c, 0, a.Length);
Array.Copy(b, 0, c, a.Length, b);

// Array.ConstrainedCopy 和 Array.Copy 差不多，更严格，不支持装拆箱

/* Buffer.BlockCopy 只支持基元类型
sbyte / byte / short / ushort / int / uint / long / ulong / char / float / double / bool

public static void BlockCopy (
	Array src,
	int srcOffset,
	Array dst,
	int dstOffset,
	int count
)
*/
Buffer.BlockCopy(a, 0, c, 0, a.Length);
Buffer.BlockCopy(b, 0, c, a.Length, b);
```
数据量小的情况下，没有太大差别，大量数据时速度比较如下
```c#
Buffer.BlockCopy > Array.ConstrainedCopy > Array.Copy > Concat
```

## 数组拆分
除了`lambda`表达式基本，就是使用复制方法，复制子数组到新数组了，如：
```c#
int[] a = new int[] { 1, 2, 3, 4, 5 };
int[] b = new int[](3);
Array.Copy(a, 0, b, 0, 3);
```

### 字符串数组 以指定间隔符 拼接成字符串
```c#
string[] a = new string[] {"1", "2"};
string s = string.Join(", ", a); // 1, 2
```

### 字符串 以指定间隔符 分割成字符串数组
```c#
// 单字符分割
string s = "a|b|c|";
string[] a = s.Split('|');	// {"a", "b", "c", ""}

// 多字符分割
string[] a = s.Split(new char[2] {'&','|'});

// 字符串分割
string[] a = Regex.Split(s,"ab",RegexOptions.IgnoreCase);
```