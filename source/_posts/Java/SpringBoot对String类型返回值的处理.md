---
title: SpringBoot对String类型返回值的处理
abbrlink: 20903
date: 2021-08-20 23:45:36
tags:
  - Java
  - Web
  - SpringBoot
---

## SpringBoot对String类型返回值的处理

**问题：**

有类似如下返回值接口：

```java
@RestController
public class TestController {

    @PostMapping(value = "test")
    public String test() throws JsonProcessingException {
        return "hello";
    }
}
```

请求返回 `json` 格式数据，返回值应为：`"hello"`，但实际收到的数据为：`hello`

**原因：**

1. SpringBoot的Message响应处理流程

    a. test() 接口执行并返回String值

    b. HandlerMethodReturnValueHandlerComposite.handleReturnValue(Object returnValue,  MethodParameter returnType, …)  {
            selectHandler（）
    }

    c. RequestResponseBodyMethodProcessor.handleReturnValue() {
            writeWithMessageConverters()
    }

`writeWithMessageConverters()`在RequestResponseBodyMethodProcessor的父类AbstractMessageConverterMethodProcessor中，其中第一个部分

```java
protected <T> void writeWithMessageConverters(@Nullable T value, MethodParameter returnType, ...) throws IOException ... {

    Object body;
    Class<?> valueType;
    Type targetType;

    // 这里直接对字符序列类型数据写入body
    if (value instanceof CharSequence) {
        body = value.toString();
        valueType = String.class;
        targetType = String.class;
    }
    else {
        body = value;
        valueType = getReturnValueType(body, returnType);
        targetType = GenericTypeResolver.resolveType(getGenericType(returnType), returnType.getContainingClass());
    }
    ... ...
```

对于字符序列的返回值做了特殊处理，直接将值toString()写入body中

第二个部分

```java
for (HttpMessageConverter<?> converter : this.messageConverters) {
    ... ...
    if (... converter.canWrite(...)) {
        body = getAdvice().beforeBodyWrite(...);
        if (body != null) {
            ... ...
            if (genericConverter != null) {
                genericConverter.write(body, targetType, selectedMediaType, outputMessage);
            }
            else {
                ((HttpMessageConverter) converter).write(body, selectedMediaType, outputMessage);
            }
        }
        else {
            logger ... ...
        }
        return; // 直接返回终止遍历
    }
}
```

进行HttpMessageConverters的遍历调用，messageConverters如下：

![HttpMessageConverters](/assets/images/springboot_string_process/HttpMessageConverters.png)

对当前返回值进行类型对应Converter适配并在能够处理时，进行处理并  返回 

![StringHttpMessageConverters](/assets/images/springboot_string_process/StringHttpMessageConverters.png)

2. 问题分析

writeWithMessageConverters() 这个方法对字符串的默认处理，以及 HttpMessageConverters 的默认顺序，以及处理返回机制，导致了String类型返回值不能呗 Jackson 的 MessageConverter 处理

**解决方案：**

1. 对返回String类型值的接口，在返回的时候进行特殊处理，例如使用fastJson:
```java
return JSON.toJSONString(returnValue)
```

2. 【推荐】对返回值进行封装成对象就不会出现问题了，如下

```json
{
    "code": 200, 
    "msg": "ok", 
    "data": "hello"
}
```

