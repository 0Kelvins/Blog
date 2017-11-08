---
title: Git命令
tags:
  - git
  - 随笔
abbrlink: b6ef4fe0
date: 2017-10-24 11:22:07
---

强制更新覆盖本地
```bash
$ git fetch --all #下载最新文件（未覆盖）
$ git reset --hard origin/master #定向最新下载版本
$ git pull #更新，已经同步远程最新文件
```