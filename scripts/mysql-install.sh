#!/bin/bash

NAME='mysql-5.7.34-linux-glibc2.12-x86_64'

# 卸载系统原有的mariadb和环境
uninstall_sql(){
	rpm -qa | grep mariadb
	if [ $? -eq 0 ];then
		yum remove mariadb* -y
	fi

	rm -rf /usr/local/mysql
	rm -f /var/log/mysql.log
	chkconfig --del mysqld
	rm -f /etc/init.d/mysqld
}


# 下载mysql5.7二进制包
download_mysql(){
	wget https://downloads.mysql.com/archives/get/p/23/file/${NAME}.tar.gz --no-check-certificate

}


# 解压移动
decompress_move(){
	tar xf ${NAME}.tar.gz
	mv ${NAME} /usr/local/mysql
}


# 创建用户，修改权限，创建日志文件
mysql_permission(){
	id mysql &> /dev/null
	if [ $? -eq 1 ];then
		useradd -M mysql -s /sbin/nologin
	fi

	chown -R mysql.mysql /usr/local/mysql
	touch /var/log/mysql.log && chown mysql.mysql /var/log/mysql.log
}


# 编辑配置文件
edit_configure(){

# 备份
[ -f /etc/my.cnf ] && cp /etc/my.cnf /etc/my.cnf.bak

cat > /etc/my.cnf <<EOF
[mysqld]
basedir=/usr/local/mysql
datadir=/usr/local/mysql/data
socket=/usr/local/mysql/data/mysql.sock
port=3306
default-storage-engine = innodb
innodb_large_prefix=on
innodb_file_per_table = on
innodb_file_per_table
max_connections = 10000
collation-server = utf8_general_ci
character_set_server=utf8
user=mysql
log-error=/var/log/mysql.log
log_bin_trust_function_creators = 1 #设置主从同步之后,向数据库导入sql文件报错
max_connect_errors = 1000	#最大连接数
[client]
port = 3306
socket = /usr/local/mysql/data/mysql.sock
default-character-set = utf8
EOF

}


# 初始化数据库，输出密码
init_mysql(){
	cd /usr/local/mysql
	./bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
	cat /var/log/mysql.log | grep password | tail -1 | awk '{print "初始密码为:" $NF}'
	echo "密码文件：/var/log/mysql.log"
}


# 加入系统服务
add_sys_service(){

cat >/usr/lib/systemd/system/mysqld.service<<EOF
[Unit]
Description=MySQL Server
Documentation=man:mysqld(8)
Documentation=http://dev.mysql.com/doc/refman/en/using-systemd.html
After=network.target
After=syslog.target
[Install]
WantedBy=multi-user.target
[Service]
User=mysql
Group=mysql
ExecStart=/usr/local/mysql/bin/mysqld --defaults-file=/etc/my.cnf
LimitNOFILE = 5000
EOF

# 添加mysql环境变量
echo "export PATH=\$PATH:/usr/local/mysql/bin" >> ~/.bashrc
source ~/.bashrc

systemctl daemon-reload
systemctl enable mysqld.service
systemctl  start mysqld

}


cat <<-EOF 
+-----------------------------------------------------+ 
            mysql_install_tools V1.0
+-----------------------------------------------------+ 
        1. 已有mysql二进制包.
        2. 没有安装包，下载mysql5.7.34二进制包
        3. Quit
+-----------------------------------------------------+ 
EOF

echo "请输入你的选择:" && read choose
case "$choose" in
	"1")
		echo "请确保mysql5.7二进制包在当前目录"
		uninstall_sql
		echo "mariadb卸载完成"
		decompress_move
		echo "mariadb卸载完成"
		mysql_permission
		echo "用户权限修改完成"
		edit_configure
		echo "配置文件编辑完成"
		init_mysql
		echo "初始化数据库完成"
		add_sys_service

		;; 
	"2")
		# 下载mysql
		echo "开始下载mysql-5.7.34二进制包"
		download_mysql
		if [ $? -eq 0 ];then
			echo "下载完成"
			uninstall_sql
			echo "mariadb卸载完成"
			decompress_move
			echo "mariadb卸载完成"
			mysql_permission
			echo "用户权限修改完成"
			edit_configure
			echo "配置文件编辑完成"
			init_mysql
			echo "初始化数据库完成"
			add_sys_service

		else
			echo "下载失败，正在重新下载"
			download_mysql
		fi
		;; 
	"3")
		exit
		;; 
	*)
		printf "请按照上方提供的选项输入!!!\n"
		;; 
esac

echo "source ~/.bashrc"

