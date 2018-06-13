---
title: Git命令
tags:
  - git
  - 随笔
abbrlink: b6ef4fe0
date: 2017-10-24 11:22:07
---

强制更新覆盖本地

```shell
git fetch --all # 下载最新文件（未覆盖）
git reset --hard origin/master # 定向最新下载版本
git pull origin master # 更新，已经同步远程最新文件

git pull origin master --allow-unrelated-histories # 允许无关联历史
```

分支变更回退

```shell
$ git reflog  # 所有分支的所有操作记录
272c92d (HEAD -> master, origin/master) HEAD@{0}: reset: moving to HEAD
272c92d (HEAD -> master, origin/master) HEAD@{1}: reset: moving to origin/master
b6acea6 HEAD@{2}: commit: update
3041a64 HEAD@{3}: commit: init
1718038 HEAD@{4}: commit: update ignore
f85aa76 HEAD@{5}: commit: init
90ba2c6 HEAD@{6}: commit (initial): init

$ git reset --hard b6acea6 # 回退到之前版本
```

删除已纳入版本控制，并后添加到`.gitignore`的文件（注意`.`）

```shell
git rm -r --cached .
git add .
git commit -m "update .gitignore"
```

修改已`commit`备注

1. 输入

```shell
git commit --amend
```

2. 进入最后一次提交的内容（vim编辑器） > `a`进入插入模式 > 修改 > `Esc` > 输入`:wq`，保存退出