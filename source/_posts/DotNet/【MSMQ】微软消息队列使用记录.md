---
title: 【MSMQ】微软消息队列使用记录
comments: true
date: 2018-05-15 14:48:39
categories: DotNet
tags:
    - middleware
    - Message Queue
    - CSharp
    - DotNet
---
### 简介

MSMQ（Microsoft Message Queue），消息队列是用于消息传输的中间存储容器，主要可以用于 **异步处理、应用解耦、流量削峰、日志处理及消息通讯等等**

### 使用记录

1. `Peek` 、 `Recieve`

    两者都是获取队列消息的方法，区别的是，`Peek` 获取后不删除队列内消息，`Recieve` 则是获取后删除对应消息

2. 异步接收消息

    异步接收消息需要先提供异步事件处理方法，然后初始化一个异步接收操作，直到接收到消息，或超时。
    ```csharp
        // 异步接收消息
        queue.PeekCompleted += new PeekCompletedEventHandler(method);
        queue.BeginPeek();

        // 异步接收并删除队列内对应消息
        queue.ReceiveCompleted += new ReceiveCompletedEventHandler(method);
        queue.BeginReceive();
        queue.BeginReceive(TimeSpan.FromMilliseconds(100));
    ```

3. 简单封装类，如需要更多方法，根据情况自行封装或者选择不封装

    ```csharp
    using System;
    using System.Messaging;

    namespace Utils
    {
        public class MessageQueueHelper : IDisposable
        {
            protected MessageQueueTransactionType transactionType = MessageQueueTransactionType.Automatic;
            protected MessageQueue queue; // 消息队列
            protected TimeSpan timeout; // 接收监听超时时间

            public MessageQueueHelper(string queuePath, int timeoutSeconds)
            {
                Createqueue(queuePath);
                queue = new MessageQueue(queuePath);
                timeout = TimeSpan.FromSeconds(Convert.ToDouble(timeoutSeconds));

                //设置当应用程序向消息对列发送消息时默认情况下使用的消息属性值
                //queue.DefaultPropertiesToSend.AttachSenderId = false;
                //queue.DefaultPropertiesToSend.UseAuthentication = false;
                //queue.DefaultPropertiesToSend.UseEncryption = false;
                //queue.DefaultPropertiesToSend.AcknowledgeType = AcknowledgeTypes.None;
                //queue.DefaultPropertiesToSend.UseJournalQueue = false;
            }

            /// <summary>
            /// 消息接收
            /// </summary>
            public virtual object Receive()
            {
                try
                {
                    using (Message message = queue.Receive(timeout, transactionType))
                        return message;
                }
                catch (MessageQueueException e)
                {
                    LogHelper.ErrorLog(typeof(MessageQueueHelper), e, "队列接收消息异常！");
                    if (e.MessageQueueErrorCode == MessageQueueErrorCode.IOTimeout)
                        throw new TimeoutException();

                    throw e;
                }
            }

            /// <summary>
            /// 消息发送
            /// </summary>
            public virtual void Send(object msg)
            {
                queue.Send(msg, transactionType);
            }

            /// <summary>
            /// 创建使用指定路径的新消息队列
            /// </summary>
            /// <param name="queuePath">队列存储路径</param>
            public static void Createqueue(string queuePath)
            {
                try
                {
                    if (!MessageQueue.Exists(queuePath))
                    {
                        MessageQueue.Create(queuePath, true);
                    }
                }
                catch (MessageQueueException e)
                {
                    throw e;
                }
            }

            #region 实现 IDisposable 接口成员
            public void Dispose()
            {
                queue.Dispose();
            }
            #endregion
        }
    }
    ```

    进一步实现特定队列

    ```csharp
    using System;
    using System.Collections.Generic;
    using System.Messaging;
    using Newtonsoft.Json;
    using System.Threading;
    using Utils; // Helper的命名空间

    namespace API.App_Start
    {
        public class ReceiveProcessQueue : MessageQueueHelper
        {
            // 获取配置文件中有关消息队列路径的参数
            private static readonly string queuePath = @".\private$\rpmsmq";
            private static int queueTimeout = 30;

            public ReceiveProcessQueue()
                : base(queuePath, queueTimeout)
            {
                // 设置消息的序列化方式
                queue.Formatter = new XmlMessageFormatter(new Type[] { typeof(string) });
            }

            /// <summary>
            /// 接收消息
            /// </summary>
            public void ReceiveData()
            {
                // 指定消息队列事务的类型，Automatic枚举值允许发送发部事务和从外部事务接收
                transactionType = MessageQueueTransactionType.Automatic;
                Message msg = (Message)base.Receive();
                Process(msg);
            }

            /// <summary>
            /// 接收消息指定超时时间
            /// </summary>
            /// <param name="timeout">超时时间</param>
            public void ReceiveData(int timeout)
            {
                base.timeout = TimeSpan.FromSeconds(Convert.ToDouble(timeout));
                ReceiveData();
            }

            /// <summary>
            /// 异步消息接收
            /// </summary>
            /// <param name="method">异步处理方法</param>
            public void ReceiveByAsync()
            {
                queue.ReceiveCompleted += new ReceiveCompletedEventHandler(ReceiveCompleted);
                // 指定初始化异步并行处理数量
                #if !DEBUG
                int MAX_THREAD = 16;
                #else
                int MAX_THREAD = 3;
                #endif
                for (int i = 0; i < MAX_THREAD; i++)
                {
                    queue.BeginReceive();
                }
            }

            /// <summary>
            /// 异步处理方法
            /// </summary>
            /// <param name="source">队列</param>
            /// <param name="asyncResult">异步结果</param>
            public void ReceiveCompleted(Object source, ReceiveCompletedEventArgs asyncResult)
            {
                MessageQueue queue = (MessageQueue)source;
                queue.Formatter = new XmlMessageFormatter(new Type[] { typeof(string) });
                // 完成指定的异步接收操作
                Message msg = queue.EndReceive(asyncResult.AsyncResult);
                Process(msg);
                // 消息处理完成后，初始化新的异步接收操作
                queue.BeginReceive();
            }

            /// <summary>
            /// 发送消息
            /// </summary>
            /// <param name="msg">消息</param>
            public void SendData(string msg)
            {
                // 指定消息队列事务的类型，Single枚举值用于单个内部事务的事务类型
                base.transactionType = MessageQueueTransactionType.Single;
                base.Send(msg);
            }

            public void Process(Message msg)
            {
                string msgStr = null;
                try
                {
                    if (ReferenceEquals(msg.Body, null))
                    {
                        Console.WriteLine("null");
                        return;
                    }
                    msgStr = (string)msg.Body;
                    Console.WriteLine(msgStr);
                    Thread.Sleep(100);  // 睡眠随机时间可以看到多线程异步效果
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }
    }
    ```

### 结束

经过单元测试，测试正常，后面就要根据业务来做调整了，考虑如何提升并行处理的效率，且不会爆栈。

解决方案有：

1. 异步 + 多线程（现在的）

2. 轮询动态增减消费者（使用定时任务，定时检查队列消息数量，动态增减消费者）

需要主要对系统开销，以及应对峰值等场景的效果，进行权衡

之前写过 `RabbitMQ` 的demo，现在发现不实际使用真的是很多问题都不知道。