---
title: Sublime Terminal
date: 2017-10-26 15:50:15
tags: [Sublime,随笔]
---

无论是用Sublime写前端，还是写Markdown，经常要用到终端，每次``Win+R``再cmd也是麻烦

1. Package Control -> Terminal

2. 设置Setting-Default，就是有``"termainal":``这个参数的设置文件，改成下面设置，即可``Ctrl+Alt+T``启动普通cmd了（不改的话，默认为启动Power Shell）
``` json
{
  // Replace with your own path to cmder.exe
  "terminal": "cmd",
  "parameters": ["/START", "%CWD%"]
}
```

[Sublime插件-Terminal的Github](https://github.com/wbond/sublime_terminal)