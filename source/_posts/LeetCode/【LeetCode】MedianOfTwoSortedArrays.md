---
title: 【LeetCode】4. Median of Two Sorted Arrays
comments: true
categories: Algorithm
tags:
  - LeetCode
  - Algorithm
  - Java
abbrlink: 2a84b609
date: 2017-11-23 21:42:13
---

## 两数组的中值
题目地址：[Go to LeetCode](https://leetcode.com/problems/median-of-two-sorted-arrays/description/)

## 题意
求两个有序数组中间位置的数，两个数组长度和为偶数个时中间数求平均。
(哇，这题理解起来还是挺简单的，就是要做到`O(m+n)`有点麻烦了。)

## 解题思路
1. 归并排序（O(m+n)）
两个有序数组合并排序，这是归并排序算法的一部分。

普 通 思 路。然而我这个想法就一闪而过就没了。Orz，还去用插排了，做了半天看起来判断太多太丑了，后面直接删了。然后看了下题解，自己写了遍。（扶额

2. 二分查找（O(m,n)）
二分查找一个数组还算简单，这两个数组就有点晕了。思路的话 [LeetCode](https://leetcode.com/problems/median-of-two-sorted-arrays/solution/) 上有的，虽然是英文的，但是我没准备汉化一遍。（反正我这也没人看，略略略~

## 记
还是要多做做题，不然都忘光了。脑子已经锈实了。

