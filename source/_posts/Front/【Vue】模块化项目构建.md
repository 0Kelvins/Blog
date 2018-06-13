---
title: 【Vue】模块化项目构建
comments: true
categories: Front
tags:
  - Vue
  - VSCode
abbrlink: 1a0d7b20
date: 2018-06-13 16:44:18
---

## Vue + Typescript 模块化项目的构建

得益于 `vue-cli 3.0` 多了 `create`，项目构建变得非常的简单了

### 构建主要步骤

0. 默认已经有 `node.js` 环境，最好8+版本

1. 安装 `vue-cli 3.0`

    1.0 卸载旧版2.x版本，如果有的话

    1.1 `npm i -g @vue/cli`，（chromedriver可能安装失败，需要从taobao镜像安装缓存，然后再安装cli）

    1.2 `vue -V` 确认版本为 3.x（目前为3.0.0-beta.16）

2. 使用 `vue-cli` 构建框架

```shell
> vue create vue

Vue CLI v3.0.0-beta.16
? Please pick a preset: Manually select features

? Check the features needed for your project:
 (*) Babel
 (*) TypeScript
 ( ) Progressive Web App (PWA) Support # 网页App
 (*) Router
 (*) Vuex
 (*) CSS Pre-processors
 (*) Linter / Formatter
 (*) Unit Testing
 ( ) E2E Testing # 端到端调试

? Use class-style component syntax? Yes

? Use Babel alongside TypeScript for auto-detected polyfills? Yes

? Pick a CSS pre-processor (PostCSS, Autoprefixer and CSS Modules are supported by default): LESS

? Pick a linter / formatter config: TSLint

? Pick additional lint features: Lint on save

? Pick a unit testing solution: Mocha

? Where do you prefer placing config for Babel, PostCSS, ESLint, etc.? In dedicated config files # 分离配置文件
```

以上为我的具体框架选择

3. `npm/yarn serve`运行即可

4. 需要修改 `webpack` 等设置，新建 `vue.config.js` 可以自定义配置，具体配置见官方 `vue-cli` 仓库-> docs -> config

    注：支持Jsx，内置webpack、babel、ts等，基本无需多余配置，开箱即用，相对2.x自己构建已经非常精简了
    ```json
    {
        "name": "vue",
        "version": "0.1.0",
        "private": true,
        "scripts": {
            "serve": "vue-cli-service serve",
            "build": "vue-cli-service build",
            "lint": "vue-cli-service lint",
            "test:unit": "vue-cli-service test:unit"
        },
        "dependencies": {
            "bootstrap-vue": "^2.0.0-rc.11",
            "vue": "^2.5.16",
            "vue-class-component": "^6.0.0",
            "vue-property-decorator": "^6.0.0",
            "vue-router": "^3.0.1",
            "vuex": "^3.0.1",
            "vuex-class": "^0.3.1"
        },
        "devDependencies": {
            "@types/chai": "^4.1.0",
            "@types/mocha": "^2.2.46",
            "@vue/cli-plugin-babel": "^3.0.0-beta.15",
            "@vue/cli-plugin-typescript": "^3.0.0-beta.15",
            "@vue/cli-plugin-unit-mocha": "^3.0.0-beta.15",
            "@vue/cli-service": "^3.0.0-beta.15",
            "@vue/test-utils": "^1.0.0-beta.16",
            "chai": "^4.1.2",
            "less": "^3.0.4",
            "less-loader": "^4.1.0",
            "vue-template-compiler": "^2.5.16"
        },
        "browserslist": [
            "> 1%",
            "last 2 versions",
            "not ie <= 8"
        ]
    }
    ```

5. VSCode调试断点，安装Debugger插件，这里用的是 `Debugger for FireFox`，配置：

```json
// launch.json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch localhost",
            "type": "firefox",
            "request": "launch",
            "reAttach": true,
            "url": "http://localhost:8080/#/",
            "webRoot": "${workspaceFolder}",
            "firefoxExecutable": "C:/Program Files/Mozilla Firefox/firefox.exe",
            "firefoxArgs": ["-start-debugger-server", "-no-remote"]
        }
    ]
}
```

服务还是要先命令行运行`yarn serve`的

### 参考

[vue-cli官网](https://cli.vuejs.org/)：有介绍及教程等（瞎折腾好久才发现）

[官方仓库vue-cli](https://github.com/vuejs/vue-cli)

[VSCode调试运行在Chrome, Firefox与Edge内的JS程序](https://cnodejs.org/topic/589330c17274550b057a5cbf)

### 记

一开始不知道有`vue-cli 3.0`，用的2.9.6，各种包一个个装，ts也要自己配置，搞了一两天，终于能跑了，但是VSCode就是提示找不到模块，想想应该是包装的太乱太杂了。3.0中间不需要按2.x一样装配ts、jsx等等，省的自己装的乱七八糟的，终于能安心看vue和ts了。