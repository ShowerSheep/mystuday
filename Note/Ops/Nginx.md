# Nginx服务

## 一、nginx编译安装，配置

### 1. 安装依赖包

```bash
yum -y install gcc gcc-c++ pcre pcre-devel gd-devel openssl openssl-devel  zlib zlib-devel
```

### 2. 创建用户nginx

```bash
useradd nginx
```

### 3. 安装

下载，解压

```bash
wget http://nginx.org/download/nginx-1.16.0.tar.gz

tar xf nginx-1.16.0.tar.gz
```

预编译

```bash
cd nginx-1.16.0/

./configure \
--prefix=/usr/local/nginx \
--group=nginx \
--user=nginx \
--with-http_stub_status_module \
--with-http_v2_module \
--with-http_ssl_module \
--with-http_gzip_static_module \
--with-http_realip_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-stream \
--with-stream_ssl_module \
--with-stream_realip_module
```

编译安装

```bash
make && make install
```

### 4. 添加环境变量

```bash
echo "export PATH=$PATH:/usr/local/nginx/sbin" >> /etc/profile.d/nginx.sh
source /etc/profile.d/nginx.sh
```

### 5. 开机自启服务

```bash
cat >/usr/lib/systemd/system/nginx.service<<EOF
[Unit]
Description=nginx
After=network.target remote-fs.target nss-lookup.target
 
[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStartPre=/usr/bin/rm -f /usr/local/nginx/logs/nginx.pid
ExecStartPost=/bin/sleep 0.1
ExecStartPre=/usr/local/nginx/sbin/nginx -t -c /usr/local/nginx/conf/nginx.conf
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true
LimitNOFILE=51200
LimitNPROC=51200
LimitCORE=51200

[Install]
WantedBy=multi-user.target
EOF
```

加载系统服务

```bash
systemctl daemon-reload
systemctl enable nginx
```



### 6. 配置文件

备份配置文件

```bash
mv /usr/local/nginx/conf/nginx.conf{,.bak}
```

覆盖配置文件

```nginx
cat >/usr/local/nginx/conf/nginx.conf<<EOF
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
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status $body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';
    access_log  logs/access.log  main;
    sendfile        on;
    tcp_nopush     on;
    keepalive_timeout  65;
    gzip  on;
    server {
        listen       80;
        server_name  localhost;
        access_log  logs/host.access.log  main;
        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}
EOF
```

`/usr/local/nginx/conf/nginx.conf` 内容

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
                      '$status  "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  logs/access.log  main;
    sendfile        on;
    tcp_nopush     on;
    keepalive_timeout  65;
    gzip  on;
    server {
        listen       80;
        server_name  localhost;
        access_log  logs/host.access.log  main;
        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}
```

检测配置文件

```bash
nginx -t
```

### 7. 命令功能

```bash
nginx -c /path/nginx.conf  	     # 以特定目录下的配置文件启动nginx:
nginx -s reload            	 	 # 修改配置后重新加载生效
nginx -s stop  				 	 # 快速停止nginx
nginx -s quit  				 	# 正常停止nginx
nginx -t    					# 测试当前配置文件是否正确
nginx -t -c /path/to/nginx.conf  # 测试特定的nginx配置文件是否正确
#注意：
nginx -s reload #命令加载修改后的配置文件
```

### 8. 日志

nginx 日志文件分为 **log_format** 和 **access_log** 两部分

log_format 定义记录的格式，其语法格式为

```config
   log_format        样式名称        样式详情
```

```nginx
log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                  '$status  "$http_referer" '
                  '"$http_user_agent" "$http_x_forwarded_for"';
```

![image-20221013100401149](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221013100401149.png)



### 9. nginx 虚拟机配置**

`server` 块配置

```nginx
server {
    listen       80;
    # 监听端口
    server_name  localhost;
    # 绑定域名
    access_log  logs/host.access.log  main;
    # 定义虚拟主机访问日志文件
    location / {
    # 定义进入网站以后的访问目录
        root   /data/html;
        # 网站代码主目录
        index  index.html index.htm;
        # 默认首页，进入网站自动打开的页面
    }
}
```

例

```nginx
http {
    include       mime.types;
    default_type  application/octet-stream;
    server {
        listen       80;
        server_name  web.testpm.com;
        location / {
            root   html;
            index  index.html index.htm;
            limit_rate	2k;
        }
    }
	server {
        listen       80;
        server_name  www.testpm.com;
        location / {
            root   /data/html;
            index  index.html index.htm;
        }
     }
}
```

在主配置文件引入方式：

新建 `/usr/local/nginx/conf/server.conf`

```nginx
server {
        listen       80;
        server_name  localhost;
        access_log  logs/web1.access.log  main;
        location / {
            root   /data/web/;
            index  index.html index.htm;
        }
}
```

在 `nginx.conf` 下添加

```nginx
include server.conf;
```



## 二、nginx proxy 反向代理

### 1. nginx proxy 配置

代理模块，默认已安装

```conf
ngx_http_proxy_module
```

启动nginx proxy代理需要两台服务器

#### 1. nginx-1 启动网站（内容）

后端应用服务器

有可以访问的网站内容

IP地址：192.168.1.142

#### 2. nginx-2 代理服务器

IP：192.168.1.139

nginx配置文件 `nginx.conf`

```nginx
server {
        listen       80;
        server_name  localhost;
        #定义server主机的访问日志
        access_log  logs/proxy.access.log  main;
        location / {
            proxy_pass http://192.168.1.142:80;		# 要代理的服务器
            proxy_redirect default;
            proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_connect_timeout 30;
            proxy_send_timeout 60;
            proxy_read_timeout 60;
        }
}
```

>配置详解
>
>proxy_pass ：真实后端服务器的地址，可以是ip也可以是域名和url地址
>proxy_redirect ：如果真实服务器使用的是的真实IP:非默认端口。则改成IP：默认端口。
>proxy_set_header：重新定义或者添加发往后端服务器的请求头
>proxy_set_header X-Real-IP $remote_addr;#只记录连接服务器的上一个ip地址信息。
>proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; #通过这个选项可以记录真正客户端机器的ip地址
>proxy_connect_timeout：:后端服务器连接的超时时间发起三次握手等候响应超时时间
>proxy_send_timeout：后端服务器数据回传时间，就是在规定时间之内后端服务器必须传完所有的数据
>proxy_read_timeout ：nginx接收upstream（上游/真实） server数据超时, 默认60s, 如果连续的60s内没有收到1个字节, 连接关闭。像长连接

重载nginx服务

```bash
nginx -s reload
```

#### 3. 测试访问

输入nginx-2的服务器地址，成功访问nginx-1的内容



### 2. 公网私网代理配置

#### 1. nginx-2添加网卡配置

代理服务器添加一块网卡，一块NAT，一块桥接

 ![image-20221013170936668](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221013170936668.png)

nginx-1 内容服务器，192.168.1.142

nginx-2 代理服务器，192.168.1.143

打开nginx-2

 ![image-20221013171556973](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221013171556973.png)

图形化编辑网卡配置

```bash
nmtui
```

 ![image-20221013171842956](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221013171842956.png)

ens36配置

 ![image-20221013172528006](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221013172528006.png)

DNS服务器填写windows主机的网络属性的DNS



ens33配置

 ![image-20221013172743912](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221013172743912.png)

back quit退出

![image-20221013173231989](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221013173231989.png)

查看nginx是否开启

#### 2.测试

其他人浏览器访问`10.36.139.52`



## 三、nginx 负载均衡（七层）

### 1. upstream 配置

配置文件

```nginx
server {
        ....
        location / {
        .....
           proxy_pass  http://testapp;  #请求转向 testapp 定义的服务器列表
        ........
        }   
}
##定义负载均衡组名称
upstream testapp { 
      server 192.168.1.142:80;
      server 192.168.1.142:81;
      server 192.168.1.142:82;
}
```

### 2. 负载均衡算法

upstream 支持4种负载均衡调度算法

1、轮询(默认):每个请求按时间顺序逐一分配到不同的后端服务器;

2、ip_hash:每个请求按访问IP的hash结果分配，同一个IP客户端固定访问一个后端服务器。可以保证来自同一ip的请求被打到固定的机器上，可以解决session问题。(常用,会话保持)

3、url_hash:按访问url的hash结果来分配请求，使每个url定向到同一个后端服务器。

4、fair:这是比上面两个更加智能的负载均衡算法。此种算法可以依据页面大小和加载时间长短智能地进行负载均衡，也就是根据后端服务器的响应时间来分配请求，响应时间短的优先分配。Nginx本身是不支持 fair的，如果需要使用这种调度算法，必须下载Nginx的 upstream_fair模块。

### 3. 实例

#### 1. 热备

如果两台服务器，一台宕机启用另一台

```nginx
upstream myweb {
	server 192.168.1.142:80; 
	server 192.168.1.143:80 backup;  #热备     
}
```

#### 2. 轮询

nginx默认就是轮询其权重都默认为1，服务器处理请求的顺序：ABABABABAB....

```nginx
upstream myweb {
	server 192.168.1.142:80; 
	server 192.168.1.143:80;   
}
```

#### 3. 加权轮询

```nginx
upstream myweb {
	server 192.168.1.142:80 weight=1; 
	server 192.168.1.143:80 weight=2;   
}
```

#### 4. ip_hash

nginx会让相同的客户端ip请求相同的服务器

```nginx
upstream myweb {
	ip_hash;
	server 192.168.1.142:80; 
	server 192.168.1.143:80;   
}
```

### 4. nginx 负载均衡配置状态参数

> ```bash
> - down，表示当前的server暂时不参与负载均衡。
> - backup，预留的备份机器。当其他所有的非backup机器出现故障或者忙的时候，才会请求backup机器，因此这台机器的压力最轻。
> - max_fails，允许请求失败的次数，默认为1。当超过最大次数时，返回proxy_next_upstream 模块定义的错误。
> - fail_timeout，在经历了max_fails次失败后，暂停服务的时间单位秒。max_fails可以和fail_timeout一起使用。
> ```

```nginx
upstream myweb {
	server 192.168.1.142:80 weight=1 max_fails=2 fail_timeout=2; 
	server 192.168.1.143:80 weight=2 max_fails=2 fail_timeout=2;   
}
```



## 四、四层与七层后端建康检测模块

配置文档网址

模块地址

https://github.com/zhouchangxun/ngx_healthcheck_module/blob/master/README-zh_CN.md

主要特性：

- 同时支持四层和七层后端服务器的健康检测
- 四层支持的检测类型：tcp / udp / http
- 七层支持的检测类型：http / fastcgi
- 提供一个统一的http状态查询接口，输出格式：html / json / csv

### 1. 全新安装

创建nginx用户

```bash
useradd -M nginx -s /sbin/nologin
```

安装依赖

```bash
yum install  pcre pcre-devel  opessl  openssl-devel  zlib  zlib-devel -y
```

下载解压nginx

```bash
wget  http://nginx.org/download/nginx-1.16.1.tar.gz
tar xzvf nginx-1.16.1.tar.gz 
cd nginx-1.16.1
```

nginx安装补丁

```bash
yum install patch -y

patch -p1 < ../ngx_healthcheck_module-master/nginx_healthcheck_for_nginx_1.16+.patch
```

安装nginx

```bash
./configure \
--prefix=/usr/local/nginx \
--group=nginx \
--user=nginx \
--with-http_stub_status_module \
--with-http_v2_module \
--with-http_ssl_module \
--with-http_gzip_static_module \
--with-http_realip_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-stream \
--with-stream_ssl_module \
--with-stream_realip_module \
--add-module=/root/ngx_healthcheck_module-master/

make && make install
```



### 2. 平滑升级安装

安装依赖

```bash
yum install  pcre pcre-devel  opessl  openssl-devel  zlib  zlib-devel -y
```

下载解压nginx

```bash
wget  http://nginx.org/download/nginx-1.16.0.tar.gz
tar xzvf nginx-1.16.0.tar.gz 
cd nginx-1.16.0
```

nginx安装补丁

```bash
patch -p1 < ../ngx_healthcheck_module-master/nginx_healthcheck_for_nginx_1.16+.patch
```

nginx安装

```bash
./configure \
--prefix=/usr/local/nginx \
--group=nginx \
--user=nginx \
--with-http_stub_status_module \
--with-http_v2_module \
--with-http_ssl_module \
--with-http_gzip_static_module \
--with-http_realip_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-stream \
--with-stream_ssl_module \
--with-stream_realip_module \
--add-module=/root/ngx_healthcheck_module-master/
```

```bash
make
```

> 注意：在make以后不能运行make install，否则会覆盖原安装

关闭nginx服务，备份原来的nginx二进制文件

```bash
nginx -s stop
# systemctl stop nginx
mv /usr/local/nginx/sbin/nginx{,.bak}
```

升级，复制新的nginx二进制文件到 `/usr/local/nginx/sbin/`

```bash
cd ~/nginx-1.16.0
cp objs/nginx /usr/local/nginx/sbin/
```

查看结果

```bash
nginx -V
```

查看是否有模块 `ngx_healthcheck_module-master`



### 3. 建康检查用法

`nginx.conf` 七层负载检测配置样例

```nginx
http {
    server {
        listen 80;
        # status interface
        location /status {
            #健康状态监控页面html格式
            healthcheck_status;
        }
        # http front
        location / {
            proxy_pass http://test;    
            proxy_redirect default;    
            proxy_set_header Host $host;
            proxy_set_header  X-Real-IP        $remote_addr;
            proxy_set_header  X-Forwarded-For  $proxy_add_x_forwarded_for;
            proxy_set_header X-NginX-Proxy true;
        }
    }
    #负载均衡模块
    upstream test {
        # simple round-robin
        server 192.168.1.142:80;
     	server 192.168.1.142:81;
      	server 192.168.1.142:82;
        #健康检查配置
        check interval=3000 rise=2 fall=5 timeout=5000 type=http;
        #健康检查HTTP动作
        check_http_send "GET / HTTP/1.0\r\n\r\n";
        #健康状态HTTP代码2xx 3xx
        check_http_expect_alive http_2xx http_3xx;
    }
}
```

重载服务查看结果

监控页面 `http://ip/status`



## 五、四层负载均衡stream

端口不能与现有的冲突

案例

```nginx
user  nobody;
worker_processes  1;
error_log  logs/error.log;
pid        logs/nginx.pid;
events {
    worker_connections  1024;
}

# 引入 stream.conf 子配置文件
include stream.conf;

http {
    include       mime.types;
    default_type  application/octet-stream;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status  "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  logs/access.log  main;
    sendfile        on;
    tcp_nopush     on;
    keepalive_timeout  65;
    gzip  on;
}
```

新建 `stream.conf` 子配置文件

```nginx
##四层负载模块
stream {
    ##stream日志
        log_format proxy '$remote_addr [$time_local] '
                 '$protocol $status $bytes_sent $bytes_received '
                 '$session_time "$upstream_addr" '
                 '"$upstream_bytes_sent" "$upstream_bytes_received"               "$upstream_connect_time"';
    access_log logs/stream-access.log proxy ;
    open_log_file_cache off;
    ##定义TCP四层服务信息
    server {
        ##四层反代工作端口TCP
        listen 80;
        ##反代转发四层负载均衡
        proxy_pass tcp-cluster;
        ##后端服务器连接的超时时间
        proxy_connect_timeout 60s;
        #设置在客户端或被代理服务器连接上,两次连续的读取或写操作之间的超时,
        #如果在此时间内没有数据传输则连接将关闭,
        proxy_timeout 60s;
    }
    ##定义TCP四层负载均衡组
    upstream tcp-cluster {
        #会话保持
        hash $remote_addr consistent;
        server 192.168.1.133:80;
        server 192.168.1.133:81;
        server 192.168.1.133:82;
        ##四层负载健康检查，需安装第三方模块ngx_healthcheck_module
        check interval=3000 rise=2 fall=5 timeout=5000 default_down=true type=tcp;
    }
}
```

重载服务查看结果。



### 2. mysql主从 反代

在要反代的数据库服务器配置文件 `/etc/my.cnf` 中添加

```mysql
max_connect_errors = 1000
```

nginx：

`nginx.conf`

```nginx
user  nginx;
worker_processes  1;
error_log  logs/error.log;
pid        logs/nginx.pid;
events {
    worker_connections  1024;
}

include stream.conf;

http {
    include       mime.types;
    ...
}
```

新建`stream.conf`

```nginx
##四层负载模块
stream {
    ##stream日志
        log_format proxy '$remote_addr [$time_local] '
                 '$protocol $status $bytes_sent $bytes_received '
                 '$session_time "$upstream_addr" '
                 '"$upstream_bytes_sent" "$upstream_bytes_received"               "$upstream_connect_time"';
    access_log logs/stream-access.log proxy ;
    open_log_file_cache off;
    ##定义TCP四层服务信息
    server {
        ##四层反代工作端口TCP
        listen 3306;
        ##反代转发四层负载均衡
        proxy_pass tcp-cluster;
        ##后端服务器连接的超时时间
        proxy_connect_timeout 60s;
        #设置在客户端或被代理服务器连接上,两次连续的读取或写操作之间的超时,
        #如果在此时间内没有数据传输则连接将关闭,
        proxy_timeout 60s;
    }
    ##定义TCP四层负载均衡组
    upstream tcp-cluster {
        #会话保持
        hash $remote_addr consistent;
        server 192.168.1.134:3306;
        server 192.168.1.147:3306;
        server 192.168.1.143:3306;
       # server 192.168.1.133:82;
        ##四层负载健康检查，需安装第三方模块ngx_healthcheck_module
        check interval=3000 rise=2 fall=3 timeout=5000 default_down=true type=tcp;
    }
}
```

mysql：

所有要反代的数据库都设置

```mysql
grant all privileges on *.* to 'test'@'%' identified by '123456';
flush privileges;
```

测试：

使用navicat测试连接

 ![image-20221018205213550](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221018205213550.png)

输入反代的ip查看结果。





## 六、nginx访问控制模块

### 1. nginx 访问控制模块

> （1）基于IP的访问控制：`http_access_module`
> （2）基于用户的信任登录：`http_auth_basic_module`

### 2. 基于ip的访问控制

#### 1. 配置语法

```nginx
Syntax：allow address | all;
default：默认无
Context：http，server，location

Syntax：deny address | all;
default：默认无
Context：http，server，location
===================================================
allow    允许     //ip或者网段
deny    拒绝     //ip或者网段
```

例

```nginx
server {
	listen 80;
	server_name localhost;
	location  / {
		root /usr/share/nginx/html;
		index index.html index.hml;
		deny 192.168.1.8;
		allow all;
	}
}
```

> 需要注意:
>
> 1.按顺序匹配，已经被匹配的ip或者网段，后面不再被匹配。
> 2.如果先允许所有ip访问，在定义拒绝访问。那么拒绝访问不生效。
> 3.默认为allow all

#### 2. 指定 location拒绝所有请求

```nginx
server {
	listen 80;
	server_name localhost;
	location  / {
		root /usr/share/nginx/html;
		index index.html index.hml;
		deny all;    #拒绝所有
	}
}
```

#### 3. 测试

```bash
nginx -t

nginx -s reload
```

输入ip地址

### 3. 基于用户的信任控制

> 基于用户的信任登录模块：`http_auth_basic_module`

#### 1. 语法

```nginx
Syntax：auth_basic string | off;
default：auth_basic off;
Context：http，server，location

Syntax：auth_basic_user_file file;
default：默认无
Context：http，server，location

# file：存储用户名密码信息的文件。
```

例

```nginx
server {
	listen 80;
	server_name localhost;
	location ~ /admin {
		root /var/www/html;
		index index.html index.hml;
		auth_basic "Auth access test!";
		auth_basic_user_file  /usr/local/nginx/conf/auth_conf;
	}
}
```

> `auth_basic`不为`off`，开启登录验证功能，`auth_basic_user_file`加载账号密码文件。

#### 2. 建立口令文件

```bash
yum install -y httpd-tools

touch /usr/local/nginx/conf/auth_conf

htpasswd -m  -b  /usr/local/nginx/conf/auth_conf user01 '123456'
# -m MD5加密,-b 不使用交互式输入，指定口令为123456

htpasswd -m /usr/local/nginx/conf/auth_conf user02
cat /usr/local/nginx/conf/auth_conf
```

> htpasswd 是开源 http 服务器 apache httpd 的一个命令工具，用于生成 http 基本认证的密码文件

#### 3. 测试

```bash
nginx -t

nginx -s reload
```

> `http://ip/admin` ，是否提示用户名与口令









## 七、nginx监控模块

nginx 提供了 `ngx_http_stub_status_module` 这个模块提供了基本的监控功能

### 1. 基本活跃指标

> Accepts（接受）、Handled（已处理）、Requests（请求数）是一直在增加的计数器。Active（活跃）、Waiting（等待）、Reading（读）、Writing（写）随着请求量而增减。

1.服务器错误率

通过监控固定时间间隔内的错误代码（4XX代码表示客户端错误，5XX代码表示服务器端错误）。

2.请求处理时间

请求处理时间也可以被记录在 `access log` 中，通过分析 `access log`，统计请求的平均响应时间。 

----`$request_time` 变量

### 2. nginx Stub Status 监控模块安装

默认安装，通过 `nginx -V` 来查看是否已经安装

### 3. 配置

```nginx
server {
    listen 80;
    server_name localhost;
    location /nginx-status {
        stub_status     on;
        access_log      on;
    }
}
```

### 4. nginx 状态查看

在浏览器输入 `ip或域名/nginx-status` 查看

 ![image-20221021090240941](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221021090240941.png)

### 5. 参数说明

![image-20221021090106965](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221021090106965.png)



## 八、nginx日志切割

### 1. 利用 logrotate 日志轮转工具切割

> logrotate 是一个基于cron的日志文件管理工具。用来把旧的日志文件删除，并创建新的日志文件，可以根据日志文件的大小，也可以根据其天数来转储，这种行为称为日志转储或滚动。
> 默认centos7会自动安装logrotate。

```bash
vim  /etc/logrotate.d/nginx
```

```nginx
/usr/local/nginx/logs/*.log {           #指定需要轮转处理的日志文件
    daily            #日志文件轮转周期，可用值为: daily/weekly/yearly
    missingok             # 忽略错误信息
    rotate 7               # 轮转次数，即最多存储7个归档日志，会删除最久的归档日志
    minsize 5M	       #限制条件，大于5M的日志文件才进行分割，否则不操作
    dateext             # 以当前日期作为命名格式
    compress         # 轮循结束后，已归档日志使用gzip进行压缩
    delaycompress    # 与compress共用，最近的一次归档不要压缩
    notifempty         # 日志文件为空，轮循不会继续执行
    create 640 nginx nginx     #新日志文件的权限
    sharedscripts     #有多个日志需要轮询时，只执行一次脚本
    postrotate    # 将日志文件转储后执行的命令。以endscript结尾，命令需要单独成行
    if [ -f /usr/local/nginx/logs/nginx.pid ]; then    #判断nginx的PID。# 默认logrotate会以root身份运行
        kill -USR1 `/usr/local/nginx/logs/nginx.pid`  #-USR1 重新打开日志文件信号
    fi
    endscript
}
```

### 2. 强制切割

```bash
/usr/sbin/logrotate -f /etc/logrotate.conf
```

查看结果

### 3. 计划任务

```bash
cat >>/var/spool/cron/root<<EOF
59 23 * * * /usr/sbin/logrotate -f /etc/logrotate.conf
EOF
```

### 4. 脚本自定义

```bash
cat /data/shell/nginx-log.sh

#!/bin/bash
s_log="/usr/local/nginx/logs/access.log"
d_log="${s_log}-$(date +%Y%m%d%H%M%S)"
if [ -f "$s_log" ];then
        mv "$s_log" "$d_log"
fi
kill -USR1 `cat /usr/local/nginx/logs/nginx.pid`

# 定时执行
cat >>/var/spool/cron/root<<EOF
59 23 * * * /bin/bash /data/shell/nginx-log.sh>/dev/null
EOF
```



## 九、nginx支持php

### 1. 布署php-fpm以及php扩展

#### 1. 配置remi仓库源与epel源

```bash
yum install -y  epel-release
yum install -y  https://mirrors.aliyun.com/remi/enterprise/remi-release-7.rpm
```

查看仓库源
```bash
ls /etc/yum.repos.d/ | egrep "epel|remi*"
```

#### 2. 安装php以及扩展包

安装php7.4以及扩展包

```bash
yum --enablerepo=remi-php74 install php-fpm php-common php-devel php-mysqlnd php-mbstring php-mcrypt php-bcmath php-cli php-gd php-imap  php-ldap php-mysql php-odbc php-pdo php-pear php-pecl-igbinary  php-xml php-xmlrpc php-opcache php-intl php-pecl-memcache php-pear-Auth-SASL php-pear-Date php-pear-HTTP-Request php-pear-Mail php-pear-Net-Sieve php-pear-Net-Socket php-pear-Net-SMTP php-pear-Net-* -y
```

查看php版本

```bash
php -v
```

安装php5.6以及扩展包

```bash
yum --enablerepo=remi,remi-php56 install  -y php-fpm php-common php-devel php-mysqlnd php-mbstring php-mcrypt php-bcmath php-cli php-gd php-imap  php-ldap php-mysql php-odbc php-pdo php-pear php-pecl-igbinary  php-xml php-xmlrpc php-opcache php-intl php-pecl-memcache php-pear-Auth-SASL php-pear-Date php-pear-HTTP-Request php-pear-Mail php-pear-Net-Sieve php-pear-Net-Socket php-pear-Net-SMTP php-pear-Net-* 
```

### 2. nginx整合php-fpm

#### 1. 修改php-fpm参数

> /etc/php-fpm.d/www.conf
> 修改该文件中的user和group，与nginx.conf中的user一致。
> 将
> ;listen.owner = nobody
> 改为
> listen.owner = nginx
> 将
> ;listen.group= nobody
> 改为
> listen.group = nginx
> 将
> ;listen.mode = 0660改为
> listen.mode = 0660
> 将
> user = apache
> group = apache
> 改为
> user = nginx
> group = nginx

#### 2. 修改目录权限

```bash
chown -R nginx:nginx /var/lib/php/
```

#### 3. 修改nginx服务帐号

```bash
vim /usr/local/nginx/conf/nginx.conf
```

用户修改

```nginx
user nginx;
```

#### 4. 修改nginx配置文件，支持php解析

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
	location ~ \.php$ {
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

#### 5. 检测配置文件

```bash
nginx -t
```

#### 6. 创建测试页

在网站主目录下创建php测试页
以默认网站主目录/usr/local/nginx/html为例：

```bash
echo "<?php phpinfo(); ?>" >/usr/local/nginx/html/info.php
```

#### 7. 授权主目录

```bash
chown -R nginx:nginx /usr/local/nginx/html/
```

### 3. php-fpm服务开机自启

```bash
systemctl enable php-fpm
systemctl start php-fpm && nginx -s reload
```

查看工作端口

```bash
netstat -ntpl
```

### 4. 测试php页面

> http://ip域名/info.php
>
> http://192.168.1.133/info.php

![image-20221018170108335](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221018170108335.png)



### 5. 布署php应用

以wordpress为例

LNMP

nginx+php :192.168.1.133

mysql : 192.168.1.134

nginx+php:

上传文件，解压

```bash
tar xf wordpress-6.0.2-zh_CN.tar.gz
cd wordpress
cp -R ./* /usr/local/nginx/html/
```

mysql:

```mysql
create database wordpress;

grant all privileges on wordpress.* to 'wordpress'@'192.168.1.%' identified by '123456';

flush privileges;
```

浏览器访问 `192.168.1.133` 查看结果



## 十、php-fpm分离布署



### 1. php-fpm服务器安装



### 2. 修改php-fpm参数

```bash
vim /etc/php-fpm.d/www.conf
```

修改该文件中的user和group，与nginx.conf中的user一致。

> 将
> `user = apache`
> `group = apache`
> 改为
> `user = root`
> `group = root`
>
> `listen = 0.0.0.0:9000`
> 将
> `listen.allowed_clients = 127.0.0.1`
> 改为nginxIP
> `listen.allowed_clients = 10.36.107.138`
> 禁止开机自启
> `systemctl disable php-fpm`

### 3. 添加php代码目录

与nginx中主目录一致，添加首页，并将php代码放此目录下

```bash
mkdir /usr/local/nginx/html -p
echo "<?php phpinfo(); ?>" >/usr/local/nginx/html/index.php
```



### 4. nginx 添加php支持

nginx_IP:10.36.107.138

```
server {
        listen       80;
        server_name  localhost;
        access_log  logs/host.access.log  main;
        root html;
        location / {
                root   html;
                index index.php index.html index.htm;
        }
        location ~ \.php$ {
        root html;
        ##定义php网站目录，php-fpm服务器上保持相同目录结构
        fastcgi_pass   192.168.1.153:9000;
        ##指定php-fpm服务器地址
        fastcgi_index  index.php;
        #指定首页
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
        #include fastcgi.conf;
        }
}
```

```
多台php-fpm负载
server {
	listen       80;
	server_name  localhost;
	access_log  logs/host.access.log  main;
	location / {
		root   html;
		index index.php index.html index.htm;
	}
	location ~ \.php$ {
        root html;
        ##定义php网站目录
        fastcgi_pass   php_server;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
        #include fastcgi.conf;
	}
}
upstream  php_server{
	ip_hash;
	server 10.36.107.100:9000;
	server 10.36.107.101:9000;
	#健康检查配置,需安装第三方模块ngx_healthcheck_module
	#check interval=3000 rise=2 fall=5 timeout=5000 type=tcp;
}
#定义监控页面
server {
	listen       9080;
	server_name  localhost;
	location / {
		healthcheck_status;
	}
}
```



### 5. 启动php-fpm

php修改

```bash
vim /etc/php-fpm.d/www.conf
```

> user = root
>
> group = root
>
> listen = 0.0.0.0:9000
>
> listen.allowed_clients = 192.168.1.133



手工以root用户在后台运行(强制)

```bash
/usr/sbin/php-fpm -R

mkdir /run/php-fpm/
touch /run/php-fpm/php-fpm.pid/
```

使用`rc.local`开机自启

```bash
chmod o+x /etc/rc.local
echo '/usr/sbin/php-fpm -R' >>/etc/rc.local
systemctl enable rc-local
systemctl start rc-local
```

### 6. nginx重载配置

```bash
# 检查语法正误
nginx -t

#重载
nginx -s reload
```

### 7. 验证

> nginxip/index.php

![image-20221018215350473](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221018215350473.png)





