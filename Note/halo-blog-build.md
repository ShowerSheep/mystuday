# Halo

github地址：

https://github.com/halo-dev/halo

[官方文档](https://docs.halo.run/)

## 1.openjdk 11

```shell
yum install java-11-openjdk -y

#查看java版本
java -version
```

 ![image-20220827090530276](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827090530276.png)

## 2.halo.jar

下载地址

https://github.com/halo-dev/halo/releases



下载，放到后台运行

```shell
nohup java -jar halo-1.5.4.jar &
```

浏览器

112.74.173.36:8090

安装完成之后，下载示例配置文件到 [工作目录](https://docs.halo.run/getting-started/prepare#工作目录)

```bash
cd ~/.halo
wget https://dl.halo.run/config/application-template.yaml -O ./application.yaml 
```



## 3.使用H2

如果使用H2不需要任何操作

```bash
spring:
  datasource:
    driver-class-name: org.h2.Driver
    url: jdbc:h2:file:~/.halo/db/halo
    username: admin
    password: 123456
  h2:
    console:
      settings:
        web-allow-others: false
      path: /h2-console
      enabled: false
```



## 4.使用mysql

编辑application.yaml

```bash
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://127.0.0.1:3306/halodb?characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: root
    password: 123456
```

```bash
create database halodb character set utf8mb4 collate utf8mb4_bin;
```



### 1.卸载已有的mariadb

```bash
rpm -qa|grep mariadb	#查已安装

yum -y remove xxx	#卸载
```



### 2.解压，编译，安装

```bash
tar -zxvf mysql-5.7.38-linux-glibc2.12-x86_64.tar_2.gz -C /usr/local/

mv mysql-5.7.38-linux-glibc2.12-x86_64/ mysql

mkdir /usr/local/mysql/data
```

### 3.创建mysql用户和组

```bash
groupadd mysql
useradd -g mysql mysql

chown -R mysql.mysql ./
```

 ![image-20220825221849720](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220825221849720.png)

### 4.在etc目录下新建my.cnf

```bash
touch /etc/my.cnf
```

```config
[mysql]
# 设置mysql客户端默认字符集
default-character-set=utf8
socket=/var/lib/mysql/mysql.sock
[mysqld]
skip-name-resolve
#设置3306端⼝
port = 3306
socket=/var/lib/mysql/mysql.sock
# 设置mysql的安装⽬录
basedir=/usr/local/mysql
# 设置mysql数据库的数据的存放⽬录
datadir=/usr/local/mysql/data
# 允许最⼤连接数
max_connections=200
# 服务端使⽤的字符集默认为8⽐特编码的latin1字符集
character-set-server=utf8
# 创建新表时将使⽤的默认存储引擎
default-storage-engine=INNODB
lower_case_table_names=1
max_allowed_packet=16M
```

创建目录修改权限

```bash
mkdir /var/lib/mysql
chmod 777 /var/lib/mysql
```

### 5.安装：

```bash
./bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
```

![image-20220825222454619](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220825222454619.png)

密码一定记住+h<nj6(Dkpq#

### 6.服务

复制启动脚本到系统资源目录

```bash
cp ./support-files/mysql.server /etc/init.d/mysqld
```

修改/etc/init.d/mysqld

```bash
basedir=/usr/local/mysql
datadir=/usr/local/mysql/data
```

增加mysqld执行权限

```bash
chmod +x /etc/init.d/mysqld
```

将mysqld加入到系统服务

```bash
chkconfig --add mysqld
```

检查mysqld服务是否生效

```bash
chkconfig --list mysqld
```

 ![image-20220826200842002](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220826200842002.png)

随系统启动而启动

### 7.添加环境变量

编辑~/.bash_profile

```bash
export PATH=$PATH:/usr/local/mysql/bin
```

```bash
source ~/.bash_profile
```

### 8.修改密码

```mysql
mysql -u root -p

alter user user() identified by "111111";
flush privileges;
```

### 9.设置远程主机登录

```mysql
use mysql;
update user set user.Host='%' where user.User='root';
flush privileges;
```

Navicat，datagrip



## 5.安装代理服务器转发：Nginx

### 1.在 /usr/local/ 下创建 nginx ⽂件夹并进⼊

```shell
cd /usr/local/
mkdir nginx
cd nginx
```

### 2.Nginx 安装包解压到 /usr/local/nginx 中

```shell
 tar zxvf /root/nginx-1.21.6.tar.gz -C ./
```

### 3.安装依赖

```shell
yum -y install pcre-devel
yum -y install openssl openssl-devel
```

### 4.编译安装Nginx

```shell
cd nginx-1.21.6/
./configure
make && make install
```

 ![image-20220826202229826](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220826202229826.png)

### 5.启动Nginx

```shell
cd sbin/
./nginx
```

```bash
./nginx -s stop	#停止
./nginx -s reload	#重载
```

### 6.编辑nginx.conf

```bash
upstream halo {
        server 127.0.0.1:8090;
}

listen       80;
server_name  localhost;

location / {
	proxy_pass http://halo;
	proxy_set_header HOST $host;
	proxy_set_header X-Forwarded-Proto $scheme;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
```

重载nginx配置

```bash
./nginx -s reload
```













