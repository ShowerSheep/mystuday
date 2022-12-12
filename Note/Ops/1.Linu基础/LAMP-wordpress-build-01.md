# LAMP部署wordpress实例01

![8.12](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/8.12.png)

<!-- more -->

## 一、准备工作：

四台虚拟机，关闭防火墙、selinux，安装vim等常用软件，拍快照

```bash
systemctl stop firewalld
systemctl disable firewalld
setenforce 0

#查看网络连接
ping www.baidu.com

#检查是否有Base和epel仓库
ls /etc/yum.repos.d/
#换源
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
#清除，重建缓存
yum clean all && yum makecache
#安装vim等(D需要createrepo)
yum -y install vim createrepo
```

拍快照，方便恢复

## 二、部署D服务器

### 1. 部署FTP

做yum的远程仓库

```bash
yum -y install vsftpd
systemctl start vsftpd
systemctl enable vsftpd
```

上传镜像：从镜像中获取rpm包

需要将镜像挂载，才能获取到镜像中的rpm包

准备一个挂载目录：/mnt

```bash
mount CentOS-7-x86_64-DVD-1908.iso /mnt
```

采用ftp远程仓库，所以软件包目录要在ftp的对外共享的目录下： /var/ftp

```bash
cd /mnt/Packages/
cp ./*.rpm /var/ftp/pub/
createrepo /var/ftp/centos/
```

### 2. 部署NFS

部署NFS的作用是为了提供共享目录，并将源代码利用共享目录共享给web服务器（NFS-server的部署）

```bash
yum -y install nfs-utils
systemctl start nfs
systemctl enable nfs
mkdir /nfs
vim /etc/exports

/nfs *(rw,sync,no_root_squash)

exportfs -rv	#是写入生效

mkdir /nfs
```

上传项目源码到共享目录

```bash
tar xf wordpress-4.9.1-zh_CN.tar.gz
cp -r wordpress/* /nfs/
```

## 三、部署A+B两台服务器

### 1. 删除Base和epel仓库

```bash
rm -rf /etc/yum.repos.d/*
```

### 2. yum仓库准备

```bash
touch my.repo

[test]
name=test
baseurl=ftp://10.36.139.128/pub
rnabled=1

yum clean all
rm -rf /var/cache/yum/
yum makecache

yum repolist
```

### 3. 部署apache和php

```bash
yum -y install httpd php php-fpm php-mysql php-gd gd

systemctl start httpd

mkdir /nfs

rm -rf /etc/httpd/conf.d/welcome.conf

#创建wordpress.conf
vim wordpress.conf

<VirtualHost *:80>
  DocumentRoot "/nfs"
  ServerName localhost
</VirtualHost>
<Directory "/nfs">
  AllowOverride all
  Require all granted
</Directory>

```

### 4. 重启服务。让修改的配置文件生效

```bash
systemctl restart httpd
```

### 5. NFS的挂载

```bash
vim /etc/fstab

10.36.139.58:/nfs /nfs nfs defaults,_netdev 0 0

mount -a	#挂载
```



## 四、部署C服务器

### 1. 删除Base和epel仓库

同上 A+B

### 2. yum仓库部署

同上A+B

### 3. 安装数据库

```bash
yum -y install mariadb mariadb-server
systemctl start mariadb
systemctl enable mariadb
```

### 4. 数据库部署

```bash
mysqladmin -u root password 123

mysql -u root -p123

#对数据库操作
create database wordpress;
grant all on *.* to root@'%' identified by '123';
flush privileges;

exit
```

## 五、浏览器输入A B两台ip访问
