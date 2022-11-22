# zabbix 报警通知

## 一、使用公网邮箱发送邮件

### 1、打开 POP3/SMTP/IMAP服务

> **记得记录授权码，只显示一次**

 ![image-20221112160346580](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112160346580.png)

 ![image-20221112160414636](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112160414636.png)

### 2、安装MUA软件

mailx

```bash
yum install mailx -y

#查看版本
mailx -V

#注：使用新的方式--利用公网邮件服务器发送报警，需要关闭postfix服务
systemctl stop postfix
```

配置公网邮箱信息

```bash
vim /etc/mail.rc
```

在最后一行添加（以163为例）

```rc
 set from=12345678@163.com #（邮箱地址） 
 set smtp=smtp.163.com #（smtp服务器） 
 set smtp-auth-user=12345678@163.com #(用户名) 
 set smtp-auth-password=123456 #（这里是邮箱的授权密码） 
 set smtp-auth=login
```

使用mailx发邮件的方式

```bash
方式1：echo "正文内容" | mailx -s "邮件标题" 收件箱Email
方式2：mailx -s "邮件标题" 收件箱Email，回车按CTRL+D发送
参数：
-v ：显示发送的详细信息
```

测试

```bash
mailx -v -s 'hello' '123456@qq.com'
```

按 `Ctrl + D` 正常结束（`Ctrl + Shift + d`）



### 3、zabbix 添加邮件报警功能

#### 1. 添加报警媒介

![image-20221112154108328](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112154108328.png)

> 名称：sendmail                   //名称任意
> 类型：脚本
> 脚本名称：sendmail.sh
> 脚本参数：                          //一定要写，否则可能发送不成功
> {ALERT.SENDTO}
>
> //照填，收件人变量
>
> {ALERT.SUBJECT}
>
> //照填，邮件主题变量，变量值来源于‘动作’中的‘默认接收人’
>
> {ALERT.MESSAGE}
>
>  //照填，邮件正文变量，变量值来源于‘动作’中的‘默认信息’
>
> 配置完成后,不要忘记点击存档,保存你的配置。       

 ![image-20221112154300209](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112154300209.png)

#### 2. 脚本

```bash
vim /etc/zabbix/zabbix_server.conf
```

 ![image-20221112154505694](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112154505694.png)

配置文件确定脚本位置，可以修改

脚本

```bash
cd /usr/lib/zabbix/alertscripts/

vim sendmail.sh
```

```sh
#!/bin/sh 
#export.UTF-8
echo "$3" | sed s/'\r'//g | mailx -s "$2" $1
```

> $1:接受者的邮箱地址：sendto
> $2:邮件的主题：subject
> $3:邮件内容：message

修改权限

```bash
chmod u+x sendmail.sh && chown zabbix.zabbix sendmail.sh
```

#### 3. 修改admin用户的报警媒介

> 管理->用户-->Admin-->报警媒介类型->报警媒介->添加

 ![image-20221112154811227](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112154811227.png)

#### 4. 触发器配置

> 配置->主机->node1->触发器->创建触发器

 ![image-20221112154941459](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112154941459.png)

 ![image-20221112155102956](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112155102956.png)

#### 5. 动作配置

> 配置->动作->事件源下拉菜单中选择触发器->创建动作

 ![image-20221112155210273](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112155210273.png)

右上角创建动作

 ![image-20221112155316017](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112155316017.png)

 ![image-20221112155332281](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112155332281.png)

```bash
默认信息：邮件的主题

Problem:{TRIGGER.NAME}

故障恢复: {TRIGGER.NAME}

主机: {HOST.NAME1}
时间: {EVENT.DATE} {EVENT.TIME}
级别: {TRIGGER.SEVERITY}
触发: {TRIGGER.NAME}
详情: {ITEM.NAME1}:{ITEM.KEY1}:{ITEM.VALUE1}
状态: {TRIGGER.STATUS}
项目：{TRIGGER.KEY1} 
事件ID：{EVENT.ID}
```

 ![image-20221112155504290](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112155504290.png)

恢复动作同上

 ![image-20221112155622668](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112155622668.png)

### 4、测试

停掉mysql主从

![image-20221112155850844](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112155850844.png)

开启主从之后警告消失

并且邮箱发来两封邮件

![image-20221112155945051](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112155945051.png)



## 二、钉钉报警

### 1、准备工作

创建群聊，添加机器人

 ![image-20221112160617323](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112160617323.png)

 ![image-20221112160959163](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112160959163.png)

 ![image-20221112161136307](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112161136307.png)

### 2、创建python脚本

```bash
cd /usr/lib/zabbix/alertscripts/
vim dingding.py
```

```python
#!/usr/bin/python
# -*- coding: utf-8 -*-
import requests
import json
import sys
import os

headers = {'Content-Type': 'application/json;charset=utf-8'}
api_url = ""      # ---这里就是刚才复制钉钉的那个webhook

def msg(text):
    json_text= {
     "msgtype": "text",
        "at": {
            "atMobiles": [
                ""
            ],
        },
        "text": {
            "content": text
        }
    }
    print requests.post(api_url,json.dumps(json_text),headers=headers).content

if __name__ == '__main__':
    text = sys.argv[1]
    msg(text)
```

```bash
chmod 777 dingding.py
chown zabbix.zabbix dingding.py

#安装python脚本内请求模块
yum -y install python-requests python

#测试
./dingding.py 加钱换服务器
```



### 3、添加报警媒介类型

> 管理->报警媒介类型->创建媒体类型

 ![image-20221112161850521](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112161850521.png)

> 名称：dingding         #名称任意
> 类型：脚本
> 脚本名称：dingding.py
> 脚本参数：     #一定要写，否则可能发送不成功
>
> {ALERT.MESSAGE}
>
> #照填，邮件正文变量，变量值来源于‘动作’中的‘默认信息’
>
> 配置完成后,不要忘记点击存档,保存你的配置

### 4、用户添加报警媒介

> 管理---用户--Admin--报警媒介--添加

 ![image-20221112162138103](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112162138103.png)

### 5、添加动作

```bash
默认信息：邮件的主题

Problem:{TRIGGER.NAME}

故障恢复: {TRIGGER.NAME}

加钱换服务器	#--------填写钉钉关键词
主机: {HOST.NAME1}
时间: {EVENT.DATE} {EVENT.TIME}
级别: {TRIGGER.SEVERITY}
触发: {TRIGGER.NAME}
详情: {ITEM.NAME1}:{ITEM.KEY1}:{ITEM.VALUE1}
状态: {TRIGGER.STATUS}
项目：{TRIGGER.KEY1} 
事件ID：{EVENT.ID}
```

故障操作

 ![image-20221112162431588](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112162431588.png)

恢复操作

 ![image-20221112162540182](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221112162540182.png)



### 6、测试

查看钉钉机器人是否发送报警和恢复的消息