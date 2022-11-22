# RabbitMQ 消息中间件

## 1、普通集群准备环境

3台服务器都操作

1、配置hosts⽂件更改三台MQ节点的计算机名分别为rabbitmq-1、rabbitmq-2 和rabbitmq-3，然后修改hosts配置⽂件

```bash
vim /etc/hosts

127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

192.168.1.156 rabbitmq-1
192.168.1.157 rabbitmq-2
192.168.1.158 rabbitmq-3
```

2、三个节点配置安装rabbitmq软件

```bash
#安装依赖
yum install -y *epel* gcc-c++ unixODBC unixODBC-devel openssl-devel ncurses-devel

#yum安装erlang
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash
yum install erlang-21.3.8.21-1.el7.x86_64
```

测试：

```erlang
erl
```

安装rabbitmq

```url
https://github.com/rabbitmq/rabbitmq-server/releases/tag/v3.7.10
```

```bash
yum install -y rabbitmq-server-3.7.10-1.el7.noarch.rpm
```

3、启动

```bash
systemctl daemon-reload
systemctl start rabbitmq-server
systemctl enable rabbitmq-server
```

每台都操作开启rabbitmq的web访问界面：

```bash
rabbitmq-plugins enable rabbitmq_management
```

4、创建用户

**在一台机器操作**

添加用户和密码

```bash
rabbitmqctl add_user soho soso
```

设置为管理员

```bash
rabbitmqctl set_user_tags soho administrator
```

查看用户

```bash
rabbitmqctl list_users
```

设置权限

```bash
rabbitmqctl set_permissions -p "/" soho ".*" ".*" ".*"
```

> 此处设置权限时注意'.*'之间需要有空格 三个'.*'分别代表了conf权限，read权限与write权限 例如：当没有给soho设置这三个权限前是没有权限查询队列，在ui界面也看不见

5、开启用户远程登录

所有机器操作

```bash
cd /etc/rabbitmq/
cp /usr/share/doc/rabbitmq-server-3.7.10/rabbitmq.config.example /etc/rabbitmq/rabbitmq.config
```

重启服务

```bash
systemctl restart rabbitmq-server
```



## 2. 布署集群

