---
title: 【Vue】自定义radio组
comments: true
categories: Front
tags:
  - Vue
  - Bootstrap
  - JavaScript
abbrlink: 60a8fd90
date: 2017-12-01 11:47:40
---

### 需求
做出多组`radio`组，来作为选择条件的UI组件，比`select`更方便好看。

### 问题
1. 使用了`bootstrap`和`vue`，两者存在冲突，将`bootstrap`的js去掉。除了要实现`Vue`的`radio`组件外，因为`bootstrap`的js删除了，所以`radio`选中的效果没有了，需要自己用`Vue`来实现绑定点击效果。（不换掉`bootstrap`的js的话Vue的`radio`组件事件绑定就会和冲突，进而没反应）
3. 自定义组件的`v-model`，没能实现出想要的效果。待实验。

## 解决方法
### 1. `bootstrap`和`vue`冲突
本来想换成`bootstrap-vue`的js来用，发现radio的效果不一样了，最后还是要自己写选中效果，索性就把`bootstrap`的js去掉了，只用个css。

### 2. `Vue`的`radio`组件相关实现
`demo`的js
```js
// radio组件
var temp = '<label class="btn btn-default" :class="{active:checked}" :for="id">{{ label }}'
    + '<input :name="name" :id="id" type="radio" :value="value" :checked.sync="checked" v-on:click="update" ref="input"></label>';
Vue.component('radio-tag', {
    template: temp,
    props: {
        id: String,
        name: String,
        label: String,
        value: String,
        checked: Boolean    // 用来绑定初始值
    },
    methods: {
        update() {
            console.log('update');
            // ref获取dom
            if (this.$refs['input'].checked) {
                this.$emit('update', this.value);
            }
        }
    }
});

var app = new Vue({
    el: '#condition',
    data: {
        schools: [{ 'id': 'a', 'name': 'a校' },
                  { 'id': 'b', 'name': 'b校' }],
        grades: [{ 'id': 'a1', 'name': '初一' },
                 { 'id': 'a2', 'name': '初二' },
                 { 'id': 'a3', 'name': '初三' }],
        school: 'a',
        grade: 'a1'
    },
    methods: {
        updateGrades(value) {   // 回调函数
            this.school = value
        },
        updateClazzes(value) {
            this.grade = value
        }
    }
});
```

`demo`页面
```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
</head>
<body>
    <div class="container">
        <div id="condition" class="row clearfix ">
            <div class="col-md-12 column">
                <form role="form" class="form-horizontal">
                    <div class="form-group form-inline">
                        <label for="School" class="col-md-4 control-label">学校</label>
                        <div class="btn-group" data-toggle="buttons">
                            <radio-tag v-for="item in schools" :id="item.id" :name="item.id" :label="item.name" :value="item.id" :checked="school === item.id" v-on:update="updateGrades"></radio-tag>
                        </div>
                        <span>{{school}}</span>
                    </div>
                    <div class="form-group form-inline">
                        <label for="Grade" class="col-md-4 control-label">年级</label>
                        <div class="btn-group" data-toggle="buttons">
                            <radio-tag v-for="item in grades" :id="item.id" :name="item.id" :label="item.name" :value="item.id" :checked="grade === item.id" v-on:update="updateClazzes"></radio-tag>
                        </div>
                        <span>{{grade}}</span>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/vue"></script>
    <script type="text/javascript" src="index.js"></script>
</body>
</html>
```

### 小结
1. vue的语法缩写
* `v-bind`缩写`:`，例：`v-bind:id="id"`->`:id="id"`
* `v-on`缩写`@`，例：`v-on:click="update"`->`@click="update"`

    .net Razor页面中`@`冲突，可以使用`@@`，或者就不要缩写

2. vue中class绑定
* `:class="{active:isActive}"`，这个是官方例子
* `:class="{active:(model==0?true:false)}"`，表达式使用

3. 父子组件传值
* `props`属性用来父往子传值
* `$emit()`方法用来子往父传值