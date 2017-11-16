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

删除已纳入版本控制，并后添加到`.gitignore`的文件（注意`.`）
```bash
git rm -r --cached .
git add .
git commit -m 'update .gitignore'
```

修改已`commit`备注
1. 输入
```bash
git commit --amend
```
2. 进入最后一次提交的内容（vim编辑器） > `a`进入插入模式 > 修改 > `Esc` > 输入`:wq`，保存退出