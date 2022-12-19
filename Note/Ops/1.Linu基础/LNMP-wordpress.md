## 1. 布署php-fpm以及php扩展

### 1、配置remi仓库源与epel源

```bash
yum install -y  epel-release
yum install -y  <https://mirrors.aliyun.com/remi/enterprise/remi-release-7.rpm>
```

查看仓库源

```bash
ls /etc/yum.repos.d/ | egrep "epel|remi*"
```

### 2、安装php以及扩展包

安装php7.4以及扩展包***

```bash
yum --enablerepo=remi-php74 install php-fpm php-common php-devel php-mysqlnd php-mbstring php-mcrypt php-bcmath php-cli php-gd php-imap  php-ldap php-mysql php-odbc php-pdo php-pear php-pecl-igbinary  php-xml php-xmlrpc php-opcache php-intl php-pecl-memcache php-pear-Auth-SASL php-pear-Date php-pear-HTTP-Request php-pear-Mail php-pear-Net-Sieve php-pear-Net-Socket php-pear-Net-SMTP php-pear-Net-* -y
```

查看php版本

```bash
php -v
```

## 2. nginx整合php-fpm

### 1、修改php-fpm参数

> /etc/php-fpm.d/www.conf 修改该文件中的user和group，与nginx.conf中的user一致。 
>
> 将 ;listen.owner = nobody 改为 listen.owner = nginx 
>
> 将 ;listen.group= nobody 改为 listen.group = nginx 
>
> 将 ;listen.mode = 0660改为 listen.mode = 0660 
>
> 将 user = apache group = apache 改为 user = nginx group = nginx

### 2、修改nginx服务帐号

```bash
vim /usr/local/nginx/conf/nginx.conf
```

用户修改

```bash
user nginx;
```

### 3、修改nginx配置文件，支持php解析

```nginx
server {
    listen       80;
    server_name  localhost;
    location / {
        root html;
        ##添加默认首页indx.php支持
        index  index.php index.html index.htm;
    }
    ###在server区域中添加.php语言支持,在location / {……}后添加
    location ~ \\.php$ {
        root html;
        ###定义php网站目录
        ##指定php-fpm工作端口,php-fpm与nginx集成安装，则使用127.0.0.1:9000
        ##分开部署时指定php-fpm工作的IP与端口
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }

}
```

### 4、检测配置文件

```bash
nginx -t
```

## 3. php-fpm服务开机自启

```bash
systemctl enable php-fpm
systemctl start php-fpm && nginx -s reload
```

查看工作端口

```bash
netstat -ntpl
```

## 4. 以上两台wordpress相同

## 5. 布署NFS共享

### 1、10.36.139.115

上传wordpress包解压

```bash
tar xf wordpress-5.4-zh_CN.tar.gz
```

安装nfs

```bash
yum -y install nfs-utils
systemctl start nfs
systemctl enable nfs
mkdir /wordpress
vim /etc/exports

/wordpress *(rw,sync,no_root_squash)

exportfs -rv    #是写入生效
```

上传项目到共享目录

```bash
cp -r wordpress/* /wordpress/
```

进入115进行初始化设置

```
库名：wordpress 账户：lky。密码:123456。数据库地址:10.36.139.54:3306
```



### 2、10.36.139.116

查看存储端共享

```bash
showmount -e 10.36.139.115

Export list for 10.36.139.115:
/wordpress *
```

永久挂载

```bash
vim /etc/fstab

10.36.139.115:/nfs   /nfs   nfs   defaults,_netdev 0 0

mount -a    #挂载
```



直接进入网址查看是否能正常访问



## 4. nginx负载均衡

```nginx
user  nobody;
worker_processes  1;
error_log  logs/error.log;
pid        logs/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  logs/access.log  main;
    sendfile        on;
    tcp_nopush     on;
    keepalive_timeout  65;
    gzip  on;
    server {
        listen       80;
        server_name  wordpress.qf.com;
        access_log  logs/host.access.log  main;
        location / {
            proxy_pass  http://blog;
        }
    }
    upstream blog {
        server 10.36.139.115:80;
        server 10.36.139.116:80;
    }
}
```



