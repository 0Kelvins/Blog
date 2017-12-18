---
title: 【log4net】代码配置记录
comments: true
categories: DotNet
tags:
  - DotNet
  - Log
  - Config
abbrlink: '46894695'
date: 2017-12-18 17:06:07
---

> 由于不想重复配置数据库连接，希望可以通过代码动态设置`log4net`的数据库记录日志的连接，于是检索了相关的资料，踩了一些手贱的坑╮(╯_╰)╭

### 配置代码
* log4net配置类
```cs
using log4net;
using log4net.Appender;
using log4net.Config;
using log4net.Core;
using log4net.Layout;
using log4net.Repository.Hierarchy;
using System.Configuration;
using System.Reflection;
using System.Text;

namespace Utils.LogUtils
{
    public class LogConfig
    {
        private static string LOG_PATTERN = "[%date] %level [%thread][%c{1}:%line] - %m%n";
        private static string DATE_PATTERN = "yyyy-MM-dd'.log'";
        private static string LOG_FILE_PATH = "Log/";
        
        private static string connectionType = "System.Data.SqlClient.SqlConnection, System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089";
        private static string commandText = @"INSERT INTO Log ([Date],[Thread],[Level],[Logger],[Message],[Exception]) VALUES (@log_date, @thread, @log_level, @logger, @message, @exception)";

        /// <summary>
        /// 本地日志设置
        /// </summary>
        public static void LocalConfig()
        {
            Hierarchy hierarchy = (Hierarchy)LogManager.GetRepository();

            PatternLayout patternLayout = new PatternLayout();
            patternLayout.ConversionPattern = LOG_PATTERN;
            patternLayout.ActivateOptions();

            // 控制台输出的日志
            TraceAppender tracer = new TraceAppender();
            tracer.Layout = patternLayout;
            tracer.ActivateOptions();
            hierarchy.Root.AddAppender(tracer);

            // 滚动文件日志
            RollingFileAppender roller = new RollingFileAppender();
            roller.Layout = patternLayout;
            roller.AppendToFile = true;
            roller.RollingStyle = RollingFileAppender.RollingMode.Date;
            roller.MaxSizeRollBackups = 4;
            roller.MaximumFileSize = "1MB";
            roller.StaticLogFileName = false;
            roller.File = LOG_FILE_PATH;
            roller.DatePattern = DATE_PATTERN;
            roller.Encoding = Encoding.UTF8;
            roller.ActivateOptions();
            hierarchy.Root.AddAppender(roller);
            
            hierarchy.Root.Level = log4net.Core.Level.All;
            hierarchy.Configured = true;
            
            BasicConfigurator.Configure(roller);

            LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType).Info("本地日志启动");
        }

        /// <summary>
        /// 数据库日志设置
        /// </summary>
        public static void DataBaseConfig()
        {
            // 从web.config的appSetting节点获取配置的数据库连接
            string connectionString = ConfigurationManager.AppSettings["DBConnection"].ToString();

            Hierarchy hierarchy = (Hierarchy)LogManager.GetRepository();

            PatternLayout patternLayout = new PatternLayout();
            patternLayout.ConversionPattern = LOG_PATTERN;
            patternLayout.ActivateOptions();

            TraceAppender tracer = new TraceAppender();
            tracer.Layout = patternLayout;
            tracer.ActivateOptions();
            hierarchy.Root.AddAppender(tracer);
                        
            // ado.net数据库日志
            AdoNetAppender appender = new AdoNetAppender();
            appender.Name = "adoNetAppender";

            appender.ConnectionType = connectionType;
            appender.ConnectionString = connectionString;
            appender.CommandText = commandText;
            appender.CommandType = System.Data.CommandType.Text;
            appender.BufferSize = 1;

            AdoNetAppenderParameter parameter = new AdoNetAppenderParameter();
            parameter.DbType = System.Data.DbType.Date;
            parameter.ParameterName = "@log_date";
            parameter.Size = 255;
            parameter.Layout = new RawTimeStampLayout();
            appender.AddParameter(parameter);
            
            parameter = new AdoNetAppenderParameter();
            parameter.DbType = System.Data.DbType.String;
            parameter.ParameterName = "@thread";
            parameter.Size = 50;
            patternLayout = new PatternLayout("%thread");
            parameter.Layout = new Layout2RawLayoutAdapter(patternLayout);
            appender.AddParameter(parameter);
            
            parameter = new AdoNetAppenderParameter();
            parameter.DbType = System.Data.DbType.String;
            parameter.Size = 50;
            parameter.ParameterName = "@log_level";
            patternLayout = new PatternLayout("%level");
            parameter.Layout = new Layout2RawLayoutAdapter(patternLayout);
            appender.AddParameter(parameter);

            parameter = new AdoNetAppenderParameter();
            parameter.DbType = System.Data.DbType.String;
            parameter.ParameterName = "@logger";
            parameter.Size = 255;
            patternLayout = new PatternLayout("%logger");
            parameter.Layout = new Layout2RawLayoutAdapter(patternLayout);
            appender.AddParameter(parameter);

            parameter = new AdoNetAppenderParameter();
            parameter.DbType = System.Data.DbType.String;
            parameter.ParameterName = "@message";
            parameter.Size = 4000;
            patternLayout = new PatternLayout("%message");
            parameter.Layout = new Layout2RawLayoutAdapter(patternLayout);
            appender.AddParameter(parameter);
            
            parameter = new AdoNetAppenderParameter();
            parameter.DbType = System.Data.DbType.String;
            parameter.ParameterName = "@exception";
            parameter.Size = 2000;
            parameter.Layout = new Layout2RawLayoutAdapter(new ExceptionLayout());
            appender.AddParameter(parameter);
            
            appender.ActivateOptions();
            hierarchy.Root.AddAppender(appender);
            
            hierarchy.Root.Level = Level.All;
            hierarchy.Configured = true;

            BasicConfigurator.Configure(appender);
            LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType).Info("数据库日志启动");
        }
    }
}
```

* 日志工具类
```cs
using System;
using log4net;

namespace Utils.LogUtils
{
    /// <summary>
    /// 日志工具
    /// </summary>
    public class LogHelper
    {
        // 类型使用typeof(classname)或者MethodBase.GetCurrentMethod().DeclaringType之类的

        /// <summary>
        /// 输出异常日志
        /// </summary>
        /// <param name="type">类型</param>
        /// <param name="message">信息</param>
        /// <param name="ex">异常</param>
        public static void ErrorLog(Type type, string message, Exception ex)
        {
            ILog log = LogManager.GetLogger(type);
            log.Error(message, ex);
        }

        /// <summary>
        /// 输出调试日志
        /// </summary>
        /// <param name="type">类型</param>
        /// <param name="message">信息</param>
        public static void DebugLog(Type type, string message)
        {
            ILog log = LogManager.GetLogger(type);
            log.Debug(message);
        }

        /// <summary>
        /// 输出信息日志
        /// </summary>
        /// <param name="type">类型</param>
        /// <param name="message">信息</param>
        public static void InfoLog(Type type, string message)
        {
            ILog log = LogManager.GetLogger(type);
            log.Info(message);
        }
    }
}
```

### 小记
1. 配置的时候要严格遵守顺序，`hierarchy`要在最前面声明，不然怎么配置都无效
2. 可以通过log4net的调试日志来找问题
    在`Web.config`添加如下配置，来启动log4net的调试日志
    ```xml
    <appSettings>
        <add key="log4net.Internal.Debug" value="true"/>  
    </appSettings>
    <system.diagnostics>  
        <trace autoflush="true">  
            <listeners>  
                <add   
                    name="textWriterTraceListener"   
                    type="System.Diagnostics.TextWriterTraceListener"   
                    initializeData="D:\log4net.txt" />  
            </listeners>  
        </trace>  
    </system.diagnostics>
    ```