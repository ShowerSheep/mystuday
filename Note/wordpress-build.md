# WordPress

官网：https://cn.wordpress.org/

## 1.安装LAMP架构

1.安装apache服务

 <!-- more -->

```shell
yum -y install httpd
```

2.安装数据库

```shell
yum -y install mariadb-server mariadb
```

3.安装PHP服务

```shell
yum -y install php php-mysql php-gd gd
```

## 2.启动服务，开机启动

1.启动Apache服务

```shell
systemctl start httpd
```

2.启动mariadb服务

```shell
systemctl start mariadb
```

3..数据库和apache服务做开机启动

```shell
systemctl enable mariadb httpd
```

## 3.服务部署

```shell
mysqladmin -u root password '123'

mysql -u root -p

create database wordpress;
```

## 4.项目上传

1.解压

```shell
 tar xf wordpress-4.9.1-zh_CN.tar.gz
```

2.将项目移动到网站发布目录下（/var/www/html）

```shell
cp -r /root/wordpress/* /var/www/html/
```

3.给网站发布目录下的项目文件设置所有者和所属组为apache

```shell
chown apache.apache /var/www/html/* -R
```



## 5.配置

输入公网IP进行配置
