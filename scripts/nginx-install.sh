#!/bin/bash

first() {
    # 安装依赖包
yum -y install gcc gcc-c++ pcre pcre-devel gd-devel openssl openssl-devel  zlib zlib-devel

    # 创建nginx用户
id nginx || useradd nginx -s /sbin/nologin

    # 下载nginx源码包
[ -f ./nginx-1.16.0.tar.gz ] || wget http://nginx.org/download/nginx-1.16.0.tar.gz

tar xf nginx-1.16.0.tar.gz
}

no_health_check() {

cd nginx-1.16.0

    # 预编译
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

make && make install

}

health_check() {
cd
[ -f ./ngx_healthcheck_module-master.zip ] || echo "没有安全检测包"

unzip ngx_healthcheck_module-master.zip

yum install patch -y

cd ./nginx-1.16.0

patch -p1 < ../ngx_healthcheck_module-master/nginx_healthcheck_for_nginx_1.16+.patch

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

}




last() {

#修改PATH变量
echo  "export PATH=\$PATH:/usr/local/nginx/sbin" >> ~/.bashrc
#执行修改了环境变量的脚本
source ~/.bashrc

mv /usr/local/nginx/conf/nginx.conf{,.bak}

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
                      '\$status \$body_bytes_sent "\$http_referer" '
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
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStop=/bin/kill -s QUIT \$MAINPID
PrivateTmp=true
LimitNOFILE=51200
LimitNPROC=51200
LimitCORE=51200

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

}

cat <<-EOF
1.常规安装
2.带建康检查安装（自备插件包）
EOF

echo "请输入你的选择:" && read choose
case "$choose" in
	"1")
        first
        no_health_check
        last
        ;;

	"2")
        first
        health_check
        last
        ;;
	*)
		printf "请输入正确的数字!!!\n"
		;; 
esac




