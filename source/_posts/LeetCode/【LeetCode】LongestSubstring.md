---
title: 【LeetCode】3. Longest Substring Without Repeating Characters
comments: true
categories: Algorithm
tags: 
    - LeetCode
    - Algorithm
    - Java
abbrlink: ed2c3dd1
date: 2017-11-21 15:16:10
---

##    字符串内无重复字母的最长子串

题目地址：[Go to LeetCode](https://leetcode.com/problems/longest-substring-without-repeating-characters/description/)

### 解题思路：
字符串都是 **“字符”** 串，那就逐个 **字符** 来考虑比较呗。

定义：
* 目标串：字符串内无重复字母的最长子串
* 当前最大目标串长度：l
* 最大目标串长度:lmax

解题步骤：
1. 设定`i`为目标串第一个字符下标，逐个字符遍历
2. 比较当前字符在前面是否存在，是则`i`设置为已存在字符的下标+1（即要包含后面的字符，且不重复，只能舍弃前面的了，后面比较就从这里开始），否则当前最大目标串长度`l + 1`
3. 直到比较完当前字符前所有字符，若`l > lmax`，则`lmax = l`

### 记
Java啊什么的，各种框架用多了，总想着整体设计，但在这里这种思维可能会有点碍事。不要总想着从整体的串上来看，这样要找个这样的子串，要怎么比较呢，太麻烦了。

记得当初上数据结构的时候有一个字符串匹配算法（KMP），然后ACM里有一系列的题，我博客园还有以前的记录，那个记得是要麻烦很多的。

这题一次Ac，还算简单。倒是写这个记录写了半天= =b。嘛，太久不动脑子了，一次Ac还是蛮开心的ヽ(￣▽￣)ﾉ