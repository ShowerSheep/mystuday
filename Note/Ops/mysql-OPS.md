# mysql-Linux

## 一、安装

### 1. 编译安装mysql5.7

1、删除系统环境中的mariadb

```bash
rpm -qa | grep mariadb
yum remove mariadb* -y
```

2、创建mysql用户

```bash
useradd -M mysql -s /sbin/nologin
```

3、官网下载tar包

```bash
wget https://downloads.mysql.com/archives/get/p/23/file/mysql-boost-5.7.27.tar.gz
```

4、安装编译工具

```bash
yum -y install ncurses ncurses-devel openssl-devel bison gcc gcc-c++ make && yum -y install cmake
```

5、创建mysql目录

```bash
mkdir -p /usr/local/mysql
```

6、解压

```bash
tar xf mysql-boost-5.7.27.tar.gz -C /usr/local/
```

注:如果安装的MySQL5.7及以上的版本，在编译安装之前需要安装boost,因为高版本mysql需要boots库的安装才可以正常运行。否则会报CMake Error at cmake/boost.cmake:81错误
安装包里面自带boost包

7、编译安装

进入加压目录 `cd /usr/local/mysql-5.7.27/`

```bash
cmake . \
-DWITH_BOOST=boost/boost_1_59_0/ \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DSYSCONFDIR=/etc \
-DMYSQL_DATADIR=/usr/local/mysql/data \
-DINSTALL_MANDIR=/usr/share/man \
-DMYSQL_TCP_PORT=3306 \
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_READLINE=1 \
-DWITH_SSL=system \
-DWITH_EMBEDDED_SERVER=1 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1
```

编译安装

```bash
make && make install
```

8、初始化

```bash
cd /usr/local/mysql

chown -R mysql.mysql .
```

```bash
./bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
```

> 初始化完成之后，一定要记住提示最后的密码用于登陆或者修改密码。
>
> 只需要初始化一次

`vim /etc/my.cnf` 将文件中所有内容注释掉在添加如下内容

```bash
[client]
port = 3306
socket = /tmp/mysql.sock
default-character-set = utf8

[mysqld]
port = 3306	# 服务端口号，默认3306
user = mysql	# mysql启动用户
basedir = /usr/local/mysql  # 指定安装目录
datadir = /usr/local/mysql/data  # 指定数据存放目录
socket = /tmp/mysql.sock	# 为MySQL客户端程序和服务器之间的本地通讯指定一个套接字文件
character_set_server = utf8	# 数据库默认字符集,主流字符集支持一些特殊表情符号(特殊表情符占用4个字节)
```

9、启动mysql

```bash
cd /usr/local/mysql
./bin/mysqld_safe --user=mysql &
```

10、登录mysql

```bash
/usr/local/mysql/bin/mysql -uroot -p'!o(&>(yd!8CO'
```

11、修改密码

```bash
/usr/local/mysql/bin/mysqladmin -u root -p'!o(&>(yd!8CO'  password '123456'
```

```mysql
alter user user() identified by '123456';
update mysql.user set password_expired='N';
flush privileges;
```

```mysql
update mysql.user set authentication_string=password('123456') where user='root';
update mysql.user set password_expired='N';
flush privileges;
```



12、添加环境变量

`vim /etc/profile`

```bash
export PATH=$PATH:$HOME/bin:/usr/local/mysql/bin
```

`source /etc/profile`

```bash
mysql -u root -p
```

13、配置mysqld服务管理工具

```bash
cd /usr/local/mysql/support-files/
cp mysql.server /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig mysqld on
# 将mysql进程杀掉
pkill mysqld

/etc/init.d/mysqld start
/etc/init.d/mysqld stop
```

（13 14二选一）

14、配置系统启动服务

修改文件 `vim /lib/systemd/system/mysqld.service`

```bash
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
```

```bash
systemctl daemon-reload
systemctl enable mysqld.service
```

可以使用 `systemctl` 启动

### 2. 二进制安装

0、删除mariadb

```bash
rpm -qa | grep mariadb
yum remove mariadb*
```

1、下载

```bash
wget https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.27-linux-glibc2.12-x86_64.tar.gz
```

2、解压，移动

```bash
tar xf mysql-5.7.27-linux-glibc2.12-x86_64.tar.gz
mv mysql-5.7.27-linux-glibc2.12-x86_64 /usr/local/mysql
```

3、创建用户，修改权限，创建日志文件

```bash
useradd -M mysql -s /sbin/nologin

chown -R mysql.mysql /usr/local/mysql
touch /var/log/mysql.log && chown mysql.mysql /var/log/mysql.log
```

4、编辑配置文件

`vim /etc/my.cnf`

```bash
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
[client]
port = 3306
socket = /usr/local/mysql/data/mysql.sock
default-character-set = utf8
```

5、添加环境变量`vim /etc/profile` 或 `/root/.bashrc`

```bash
export PATH=$PATH:$HOME/bin:/usr/local/mysql/bin
```

```bash
source /etc/profile
source /root/.bashrc
```

6、初始化数据库

```bash
cd /usr/local/mysql
./bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
```

记住密码

7、复制启动脚本到资源目录

```bash
cp ./support-files/mysql.server /etc/init.d/mysqld
```

8、设置系统服务

增加权限

```bash
chmod +x /etc/init.d/mysqld
```

将mysqld服务加入到系统服务

```bash
chkconfig --add mysqld
```

检查 `mysqld` 服务是否生效

```bash
chkconfig --list mysqld
```

## 二、权限管理

### 1. 重置root账户密码

修改配置文件 `vim /etc/my.cnf` ，在 `[mysqld]` 下添加 `skip-grant-tables`

关闭Mysql使用下面方式进入Mysql直接修改表权限 

```bash
mysql -u root	# 不需要输入密码登录
```

```mysql
use mysql;
update mysql.user set authentication_string=password('123456') where user='root';
flush privileges;
```

编辑配置文件将skip-grant-tables参数前加#注释或删除skip-grant-tables此行

重启mysql

### 2. 用户登录管理

本地登录客户端命令：

```sgell
mysql -uroot -p123
```

远程登录

```bash
mysql -h192.168.0.135 -P 3306 -uroot -p'123456'

mysql -h192.168.246.253 -P 3306 -uroot -p'123' -e 'show databases;'
```

> -h	指定主机名            【默认为localhost】
> -P	MySQL服务器端口       【默认3306】
> -u	指定用户名             【默认root】
> -p	指定登录密码           【默认为空密码】
> -e	接SQL语句，可以写多条拿;隔开
>
> -D mysql为指定登录的数据库

如果报错进入server端服务器登陆mysql执行

```mysql
use mysql;
update user set host = '%' where user = 'root';
flush privileges;
```

### 3. 创建用户及授权

1. `create user` 创建用户设置密码

```mysql
create user tom@'localhost' identified by '123456';
flush privileges;
```

> %：允许所有主机远程登陆包括localhost。也可以指定某个ip，允许某个ip登陆。也可以是一个网段。
>
> localhost:只允许本地用户登录
>
> %				     所有主机远程登录
> 192.168.1.%		    192.168.1.0网段的所有主机
> 192.168.1.252		    指定主机
> localhost               只允许本地用户登录

2. `grant` 创建用户并同时授权

```mysql
grant 权限列表  on 库名.表名 to '用户名'@'客户端主机' identified by '口令'；
```

例

```mysql
grant all privileges on *.* to 'test'@'localhost' identified by '123456';
grant all privileges on *.* to 'test'@'%' identified by '123456';
flush privileges;
```

> 口令复杂性要求出错提示：
> ERROR 1819 (HY000): Your password does not satisfy the current policy requirements
> 需要把mysql默认的密码强度的取消
>
> ```mysql
> update mysql.user set password_expired='N';
> ```

3. 使用create user创建用户并设置密码后授权

```mysql
grant all on *.* to 'user'@'localhost';
flush privileges;
```

4. 修改远程登录

将原来的localhost修改为%或者ip地址

```mysql
use mysql
update user set host = '192.168.1.%' where user = 'user';
flush privileges;
```

5. 授权单独权限

```mysql
grant 权限列表 on 库名.表名 to '用户名'@'客户端主机名' identified by '123456';
```

> 权限列表
>
> all	所有权限
> select, update
> select, insert


| 权限              | 权限级别               | 权限说明                     |
| :---------------- | :--------------------- | :--------------------------- |
| CREATE            | 数据库、表或索引       | 创建数据库、表或索引权限     |
| DROP              | 数据库或表             | 删除数据库或表权限           |
| GRANT OPTION      | 数据库、表或保存的程序 | 赋予权限选项 （小心给予）    |
| ALTER             | 表                     | 更改表，比如添加字段、索引等 |
| DELETE            | 表                     | 删除数据权限                 |
| INDEX             | 表                     | 索引权限                     |
| INSERT            | 表                     | 插入权限                     |
| SELECT            | 表                     | 查询权限                     |
| UPDATE            | 表                     | 更新权限                     |
| LOCK TABLES       | 服务器管理             | 锁表权限                     |
| CREATE USER       | 服务器管理             | 创建用户权限                 |
| REPLICATION SLAVE | 服务器管理             | 复制权限                     |
| SHOW DATABASES    | 服务器管理             | 查看数据库权限               |

### 4. 刷新权限

```mysql
flush privileges;
```

### 5. 查看权限

1.查看自己的权限

```mysql
show grants;
```

2.查看别人的权限

```mysql
show grants for test;
show grants for user@'localhost';
```

 ![image-20221009104204166](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221009104204166.png)

### 6. 移除权限

```mysql
revoke 权限 on 数据库名.表名 from '用户'@'ip';
```

- 被回收的权限必须存在，否则会出错
- 整个数据库，使用 ON datebase.*；
- 特定的表：使用 ON datebase.table；

例

```mysql
revoke select,delete on *.* from jack@'%';   #回收指定权限
revoke all privileges on *.* from jack@'%';  #回收所有权限
flush privileges;
```



### 7. 修改密码

1.库外修改

```bash
mysqladmin -uroot -p'123' password 'new_password';
```

2.进入数据库修改

```mysql
set password='123456';
```

3.修改其他用户密码

```mysql
use mysql;
set PASSWORD for user3@'localhost'='123456';
```



### 8. 删除用户

1.`drop user` 删除

```mysql
drop user 'user3'@'localhost';
```

2.`selete` 删除

```mysql
delete from mysql.user where user='tom' and host='localhost';
```

删除之后刷新。



## 三、日志管理

### 1. 日志类型

![mysql-log](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/mysql-log.png)

> 1 错误日志 ：启动，停止，关闭失败报错。rpm安装日志位置 /var/log/mysqld.log #默认开启
> 2 通用查询日志：所有的查询都记下来。 #默认关闭，一般不开启
> 3 二进制日志(bin log)：实现备份，增量备份。只记录改变数据，除了select都记。
> 4 中继日志(Relay log)：读取主服务器的binlog，在slave机器本地回放。保持与主服务器数据一致。
> 5 slow log：慢查询日志，指导调优，定义某一个查询语句，执行时间过长，通过日志提供调优建议给开发人员。
> 6 DDL log： 定义语句的日志。

### 2. error log

```bash
mkdir -p /usr/local/mysql/logs/
touch /usr/local/mysql/logs/mysqld.log
chown -R mysql:mysql /usr/local/mysql/logs/
```

`/etc/my.cnf` 文件修改

```config
[mysqld]
log-error=/usr/local/mysql/logs/mysqld.log
```

重启mysql服务



### 3. Binary log

```bash
mkdir -p /usr/local/mysql/logs/mysql-bin
chown -R mysql:mysql /usr/local/mysql/logs/mysql-bin
```

`/etc/my.cnf` 文件修改

```config
[mysqld]
log-bin=/usr/local/mysql/logs/mysql-bin/mylog  #如果不指定路径默认在/var/lib/mysql
server-id=1   #AB复制的时候使用，为了防止相互复制，会设置一个ID，来标识谁产生的日志
```

重启mysql服务

查看binlog日志

```bash
mysqlbinlog mylog.000001  -v

mysqlbinlog: [ERROR] unknown variable 'default-character-set=utf8'
```

取消字符集查看binlog日志

```bash
mysqlbinlog --no-defaults mylog.000001  -v
```

> 注
>
> 1. 重启mysqld 会截断
> 2. mysql> flush logs; 会截断
> 3. mysql> reset master; 删除所有binlog,不要轻易使用，相当于：rm -rf /
> 4. 删除部分
>    mysql> PURGE BINARY LOGS TO 'mylog.000002';   #删除mysqllog.000002之前的日志
> 5. 暂停 仅当前会话
>    SET SQL_LOG_BIN=0;  #关闭
>    SET SQL_LOG_BIN=1;  #开启
>
> 解决binlog日志不记录insert语句
> 登录mysql后，设置binlog的记录格式：
> mysql> set binlog_format=statement;
> 然后，最好在my.cnf中添加：
> binlog_format=statement
> 修改完配置文件之后记得重启服务

### 4. 慢查询日志

Slow Query Log ：
慢查询开关打开后，并且执行的SQL语句达到参数设定的阈值后，就会触发慢查询功能打印出日志

```bash
mkdir /usr/local/mysql/logs/mysql-slow/
chown mysql.mysql /usr/local/mysql/logs/mysql-slow/
```

`/etc/my.cnf` 文件修改

```config
[mysqld]
slow_query_log=1  #开启
slow_query_log_file=/usr/local/mysql/logs/mysql-slow/slow.log
long_query_time=3    #设置慢查询超时间，单位是秒
```

重启mysql服务

验证查看慢查询日志

```mysql
select sleep(6);
```

```bash
cat /usr/local/mysql/logs/mysql-slow/slow.log
```

## 四、数据备份和恢复

### 1. percona-xtrabackup 物理备份 

#### 1. 安装xtrabackup

[点击前往](https://www.percona.com/downloads/Percona-XtraBackup-2.4/)

直接下载

```bash
wget https://downloads.percona.com/downloads/Percona-XtraBackup-2.4/Percona-XtraBackup-2.4.26/binary/redhat/7/x86_64/percona-xtrabackup-24-2.4.26-1.el7.x86_64.rpm

yum install percona-xtrabackup-24-2.4.26-1.el7.x86_64.rpm 
```

查看安装

```bash
rpm -qa | grep xtrabackup
xtrabackup --version
```

> 注意：
> my.cnf需要确认配置文件内有数据库目录指定
> `cat /etc/my.cnf`
> `[mysqld]
> datadir = /usr/local/mysql/data`
> 恢复时数据库目录必须为空，MySQL服务不能启动

#### 2. 完全备份流程

```bash
innobackupex --user=root --password='口令' /备份目录
```

备份目录必须存在

例

```bash
mkdir /xtrabackup
innobackupex --user=root --password='123456' /xtrabackup
```

> 完全备份恢复流程
>
> 1. 停止数据库
> 2. 清理环境
> 3. 重演回滚－－> 恢复数据
> 4. 修改权限
> 5. 启动数据库

回滚，恢复数据

```bash
innobackupex --apply-log /备份目录/完整备份目录(年月日时分秒)
```

例

```bash
innobackupex --apply-log /xtrabackup/2022-10-09_17-47-45
```

恢复数据

```bash
innobackupex --copy-back /备份目录/完整备份目录(年月日时分秒)
```

例

```bash
innobackupex --copy-back /xtrabackup/2022-10-09_17-47-45
```

完整备份恢复案例

备份以后，在 `/xtrabackup/` 产生备份时间的文件夹

1.关闭数据库

```bash
systemctl stop mysqld
```

> 注意：数据库目录必须为空，MySQL服务不能启动

```bash
rm -rf /usr/local/mysql/data/*
```

2.重演回滚

```bash
innobackupex --apply-log /xtrabackup/2022-10-09_17-47-45
```

3.确认数据库目录：
恢复之前需要确认配置文件内有数据库目录指定，不然xtrabackup不知道恢复到哪里
`cat /etc/my.cnf` 确定
`[mysqld]
datadir = /usr/local/mysql/data`

4.恢复数据

```bash
innobackupex --copy-back /xtrabackup/2022-10-09_17-47-45
```

5.修改权限

```bash
chown -R mysql:mysql chown -R mysql:mysql /usr/local/mysql/data
```

启动数据库 `systemctl start mysqld`

#### 3. 增量备份流程

1.进行完整备份

```bash
innobackupex --user=root --password='口令' /备份目录

## 例
innobackupex --user=root --password='123456' /xtrabackup
```

2.添加数据以后增量备份

增量备份语法

```bash
innobackupex --user=root --password='口令' --incremental /备份目录/ --incremental-basedir=/xtrabackup/上一备份目录

## 例
innobackupex --user=root --password='123456' --incremental /xtrabackup/ --incremental-basedir=/xtrabackup/上一备份目录(基于前一天)
# 添加数据以后增量备份(2)
innobackupex --user=root --password='123456' --incremental /xtrabackup/ --incremental-basedir=/xtrabackup/上一备份目录(基于前一天)
```

> 增量备份恢复流程(重要)
>
> 1. 停止数据库 `systemctl stop mysqld`
> 2. 清理环境 `rm -rf /usr/local/mysql/data/*`
> 3. 依次重演回滚redo log－－> 恢复数据
> 4. 修改权限 `chown -R mysql:mysql /usr/local/mysql/data`
> 5. 启动数据库 `systemctl start mysqld`

3.增量恢复重演回滚redolog 恢复数据

```bash
innobackupex --apply-log --redo-only /xtrabackup/全量目录
innobackupex --apply-log --redo-only /xtrabackup/全量目录 --incremental-dir=/xtrabackup/增量1目录
innobackupex --apply-log --redo-only /xtrabackup/全量目录 --incremental-dir=/xtrabackup/增量2目录
```

#### 4. 差异备份流程

1.完整备份

```bash
innobackupex --user=root --password='口令' /备份目录

## 例
innobackupex --user=root --password='123456' /xtrabackup
```

2.增加数据后进行差异备份

```bash
innobackupex --user=root --password='口令' --incremental /备份目录  --incremental-basedir=/xtrabackup/第一次完全备份目录
```

#### 5. 总结

```bash
完全备份流程:
完整备份语法：
innobackupex --user=root --password='口令' /备份目录
案例：
innobackupex --user=root --password='123' /xtrabackup/full

完全备份恢复流程
1. 停止数据库
2. 清理环境
3. 重演回滚－－> 恢复数据
3.重演回滚 恢复数据:
语法
innobackupex --apply-log /备份目录/完整备份目录(年月日时分秒)
案例：
innobackupex --apply-log /xtrabackup/full/2019-08-20_11-47-49
恢复数据：
语法：
innobackupex --copy-back /备份目录/完整备份目录(年月日时分秒)
案例：
innobackupex --copy-back /xtrabackup/full/2019-08-20_11-47-49
4. 修改权限
5. 启动数据库

增量备份流程
1.进行完整备份
完整备份语法：
innobackupex --user=root --password='口令' /备份目录
案例：
innobackupex --user=root --password='123' /xtrabackup
2.添加数据以后增量备份(1)
增量备份语法：
innobackupex --user=root --password='口令' --incremental /备份目录/ --incremental-basedir=/xtrabackup/上一备份目录
案例：
innobackupex --user=root --password='123' --incremental /xtrabackup/ --incremental-basedir=/xtrabackup/上一备份目录(基于前一天)
3.添加数据以后增量备份(2)
innobackupex --user=root --password='123' --incremental /xtrabackup/ --incremental-basedir=/xtrabackup/上一备份目录(基于前一天)

增量恢复流程
1. 停止数据库
2. 清理环境
3.增量重演回滚redolog 恢复数据
语法：
innobackupex --apply-log --redo-only /xtrabackup/全量目录
innobackupex --apply-log --redo-only /xtrabackup/全量目录 --incremental-dir=/xtrabackup/增量1目录
innobackupex --apply-log --redo-only /xtrabackup/全量目录 --incremental-dir=/xtrabackup/增量2目录
恢复数据
innobackupex --copy-back /xtrabackup/全量目录
4. 修改权限
5. 启动数据库

差异备份流程（重要)
1.完整备份
完整备份语法：
innobackupex --user=root --password='口令' /备份目录
案例：
innobackupex --user=root --password='123' /xtrabackup
2.增加数据后进行差异备份：
语法: 
innobackupex --user=root --password='口令' --incremental /备份目录  --incremental-basedir=/xtrabackup/第一次完全备份目录
案例：
语法: # innobackupex --user=root --password=888 --incremental /xtrabackup --incremental-basedir=/xtrabackup/完全备份目录

差异恢复流程
1. 停止数据库
2. 清理环境
差异重演回滚redo log恢复数据(重要)
1.恢复全量的redo log
语法: 
innobackupex --apply-log --redo-only /xtrabackup/完全备份目录
2.恢复差异的redo log(任意差异点)
语法：
innobackupex --apply-log --redo-only /xtrabackup/完全备份目录 --incremental-dir=/xtrabacku/某个差异备份目录
3.恢复数据
语法:
innobackupex --copy-back /xtrabackup/完全备份目录

4. 修改权限
5. 启动数据库
```





### 2. mysqldump逻辑备份---- 推荐优先使用(重点)

mysqldump 是 MySQL 自带的逻辑备份工具。可以保证数据的一致性和服务的可用性。

```
产生测试库与表
测试表:company.employee5
mysql> create database company;
mysql> CREATE TABLE company.employee5(
     id int primary key AUTO_INCREMENT not null,
    name varchar(30) not null,
    sex enum('male','female') default 'male' not null,
     hire_date date not null,
     post varchar(50) not null,
     job_description varchar(100),
     salary double(15,2) not null,
     office int,
     dep_id int
     );
mysql> insert into company.employee5(name,sex,hire_date,post,job_description,salary,office,dep_id) values 
	('jack','male','20180202','instructor','teach',5000,501,100),
	('tom','male','20180203','instructor','teach',5500,501,100),
	('robin','male','20180202','instructor','teach',8000,501,100),
	('alice','female','20180202','instructor','teach',7200,501,100),
	('tianyun','male','20180202','hr','hrcc',600,502,101),
	('harry','male','20180202','hr',NULL,6000,502,101),
	('emma','female','20180206','sale','salecc',20000,503,102),
	('christine','female','20180205','sale','salecc',2200,503,102),
    ('zhuzhu','male','20180205','sale',NULL,2200,503,102),
    ('gougou','male','20180205','sale','',2200,503,102);
```

如何保证数据一致?在备份的时候进行锁表会自动锁表。锁住之后在备份。

```bash
本身为客户端工具:
远程备份语法: # mysqldump  -h 服务器  -u用户名  -p密码   数据库名  > 备份文件.sql
本地备份语法: # mysqldump  -u用户名  -p密码   数据库名  > 备份文件.sql
```

#### **1.常用备份选项**

```
-A, --all-databases #备份所有库

-B, --databases  #备份多个数据库

-F, --flush-logs #备份之前刷新binlog日志

--default-character-set #指定导出数据时采用何种字符集，如果数据表不是采用默认的latin1字符集的话，那么导出时必须指定该选项，否则再次导入数据后将产生乱码问题。

--no-data，-d #不导出任何数据，只导出数据库表结构。

--lock-tables #备份前，锁定所有数据库表

--single-transaction #保证数据的一致性和服务的可用性

-f, --force #即使在一个表导出期间得到一个SQL错误，继续。
```

**注意**

```bash
使用 mysqldump 备份数据库时避免锁表:
对一个正在运行的数据库进行备份请慎重！！ 如果一定要 在服务运行期间备份，可以选择添加 --single-transaction选项，

类似执行： mysqldump --single-transaction -u root -p123456 dbname > mysql.sql
```

#### 2.备份表

备份整个表结构与数据

```bash
语法: # mysqldump -u root -p'口令 库名  表名 > /db1.t1.bak
[root@mysql-server ~]# mkdir /home/back  #创建备份目录
[root@mysql-server ~]# mysqldump -uroot -p'123' company employee5 > /home/back/company.employee5.bak
备份多个表：
语法: # mysqldump -u root -p'口令 库名  表名1 表名2 > /db1.t1_t2.bak
```

#### 3.备份库(重点)

```bash
备份一个库：相当于将这个库里面的所有表全部备份。
语法: # mysqldump -u root -p'口令' 库名 > /备份名.bak
[root@mysql-server ~]# mysqldump -uroot -p'123' company > /home/back/company.bak
备份多个库：
语法: # mysqldump -u root -p'口令' -B 库名1 库名2 > /备份名.bak
备份所有的库：
语法: # mysqldump -u root -p'口令 -A > /alldb.bak
[root@mysql-server ~]# mysqldump -uroot -p'123' -A > /home/back/allbase.bak
```

到目录下面查看一下：

![1566293795577](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1566293795577.png)

#### 4.恢复数据库和表

  ```bash
为保证数据一致性，应在恢复数据之前停止数据库对外的服务,停止binlog日志 因为binlog使用binlog日志恢复数据时也会产生binlog日志。
  ```

为实验效果先将刚才备份的数据库和表删除了。登陆数据库：

```bash
[root@mysql-server ~]# mysql -uroot -p123
mysql> show databases;
```

 ![1566294122629](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1566294122629.png)

```
mysql> drop database company;
mysql> \q
```

#### 5.恢复全库

```bash
登陆mysql创建一个库
mysql> create database company;
恢复：
[root@mysql-server ~]# mysql -uroot -p'123' company < /home/back/company.bak
```

#### 6.单独恢复表

```bash
登陆到刚才恢复的库中将其中的一个表删除掉
mysql> show databases;
mysql> use company;
mysql> show tables;
+-------------------+
| Tables_in_company |
+-------------------+
| employee5         |
+-------------------+
mysql> drop table employee5;
开始恢复:
查看binlog状态是否开启，如果开启则需停止
mysql>show variables like 'sql_log_bin';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| sql_log_bin   | ON    |
+---------------+-------+
#表示开启状态
mysql> set sql_log_bin=0;   #停止binlog日志
Query OK, 0 rows affected (0.00 sec)
mysql> source /home/back/company.employee5.bak;  -------加路径和备份的文件
##注意文件的路径与其他人有X权限
恢复方式二：
# mysql -u root -p1  db1  < db1.t1.bak
                     库名    备份的文件路径
```

#### 7.备份及恢复表结构

备份时不包含表内数据

```bash
1.备份表结构：
语法：mysqldump  -uroot -p'口令 -d database table > dump.sql
[root@mysql-server ~]# mysqldump -uroot -p'123' -d company employee5 > /home/back/emp.bak
恢复表结构：
登陆数据库创建一个库
mysql> create database t1;
语法：# mysql -u root -p'口令' -D 库名  < 备份文件名
[root@mysql-server ~]# mysql -uroot -p'123' -D t1 < /home/back/emp.bak
```

登陆数据查看：

![1566295893236](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1566295893236.png)

#### 8.数据的导入导出,没有表结构。

 ```bash
表的导出和导入只备份表内记录，不会备份表结构，需要通过mysqldump备份表结构，恢复时先恢复表结构，再导入数据。
 ```

```bash
mysql> show variables like "secure_file_priv";  ----查询导入导出的目录。
+------------------+-------+
| Variable_name    | Value |
+------------------+-------+
| secure_file_priv | NULL  |
+------------------+-------+
```

```bash
修改安全文件目录：
1.创建一个目录：mkdir  路径目录
[root@mysql-server ~]# mkdir /sql
2.修改权限
[root@mysql-server ~]# chown mysql:mysql /sql
3.编辑配置文件：
vim /etc/my.cnf
在[mysqld]里追加
secure_file_priv=/sql
4.重新启动mysql.
```

```bash
1.导出数据
登陆数据查看数据
mysql> show databases; 
mysql>use company;
mysql>show tables;
mysql> select * from employee5 into outfile '/sql/out-employee5.bak';
```

```bash
2.数据的导入
先将原来表里面的数据清除掉，只保留表结构
mysql> use company;
mysql> delete from employee5;
mysql> load data infile '/sql/out-employee5.bak' into table employee5;
如果将数据导入别的表，需要创建这个表并创建相应的表结构。
```



## 五、主从复制

### 1. AB复制（GTID）

#### 1. 主

`vim /etc/my.cnf` 在`[mysqld]` 下添加

```config
server-id=1
log-bin = mylog
#启用binlog
gtid_mode = on
enforce_gtid_consistency=1
#强制gtid
sync_binlog = 1 # 同步
```

重启服务 `systemctl restart mysqld`

创建账户授权

```mysql
grant replication  slave,reload,super on *.*  to 'slave'@'%' identified by '123456';
flush privileges;
```

> 注意:如果不成功删除以前的binlog日志
> replication slave：拥有此权限可以查看从服务器，从主服务器读取二进制日志。
> super权限：允许用户使用修改全局变量的SET语句以及CHANGE  MASTER语句
> reload权限：必须拥有reload权限，才可以执行flush  [tables | logs | privileges]

#### 2. 从

`vim /etc/my.cnf ` 在`[mysqld]` 下添加

```config
server-id=2
gtid_mode = ON
enforce_gtid_consistency=1
master-info-repository=TABLE
relay-log-info-repository=TABLE
```

重启服务 `systemctl restart mysqld`

进入数据库

```mysql
mysql> change master to
    -> master_host='192.168.1.140',
    -> master_user='slave',
    -> master_password='123456',
    -> master_auto_position=1;
    
change master to
master_host='192.168.1.134',
master_user='slave',
master_password='123456',
master_auto_position=1;

change master to master_host='192.168.1.134',master_user='slave',master_password='123456',master_log_file='mysql-bin.000002',master_log_pos=821301;
    
mysql> start slave;   #启动slave角色
mysql> show slave status\G  #查看状态，验证sql和IO是不是yes。
```

 ![image-20221011154333405](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221011154333405.png)

从服务器打开只读模式。

`my.cnf` 修改`mysqld`

`read_only=1`

```mysql
show variables like 'read_only'; # 查看只读是否打开
set global read_only=1;	# 打开只读
```



测试主从复制：在主服务器建库建表，从服务器查看结果。



### 2. 主从复制binlog日志

#### 1. 主

编辑主服务器的配置文件 `my.cnf`，添加如下内容

```bash
[mysqld]
server-id=1
log-bin=/usr/local/mysql/logs/mysql-bin/mylog
```

创建日志目录并赋予权限

```bash
mkdir /usr/local/mysql/logs/mysql-bin/mylog -p
chown mysql:mysql /usr/local/mysql/logs -R
```

重启服务 `systemctl restart mysqld`

在主服务器上查看binlog以及POS

```mysql
show master status\G
```

 ![image-20221012114328135](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221012114328135.png)

记录下

```
File: mylog.000001
Position: 589
```

创建主从同步用户

```mysql
GRANT REPLICATION SLAVE ON *.*  TO  'repl'@'%'  identified by '123456';
flush privileges;
```

#### 2. 从

`my.cnf`配置文件，注意server-id不能相同

```
[mysqld]
server-id=2
```

从库配置

```mysql
CHANGE MASTER TO
MASTER_HOST='192.168.1.140',
MASTER_USER='repl',
MASTER_PASSWORD='123456',
MASTER_LOG_FILE='mylog.000001',
MASTER_LOG_POS=589;
```

> 参数解释：
> CHANGE MASTER TO
> MASTER_HOST='master2.example.com',      #主服务器ip
> MASTER_USER='replication',                        #主服务器用户
> MASTER_PASSWORD='password',               #用户密码
> MASTER_PORT=3306,                                #端口
> MASTER_LOG_FILE='master2-bin.001',      #binlog日志文件名称
> MASTER_LOG_POS=4,               #日志位置

查看

```mysql
start slave;
show slave status\G
```

 ![image-20221012114806236](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221012114806236.png)



测试同步

#### 3. 故障切换

主服务器宕机

1)在salve执行：

```mysql
stop slave；
reset master；
```

2)查看是否只读模式：

```mysql
show variables like 'read_only';
```

只读模式需要修改`my.cnf`文件，注释`read-only=1`并重启mysql服务。
或者不重启使用命令关闭只读，但下次重启后失效：`set global read_only=off;`

3)查看`show slave status \G`

4)在程序中将原来主库IP地址改为现在的从库IP地址，测试应用连接是否正常



> 注意：
>
> 设置主从同步之后，向数据库导入sql文件报错，需要在
>
> `/etc/my.cnf`下的 `mysqld` 添加 `log_bin_trust_function_creators = 1`
>
> 重启数据库 `systemclt restart mysqld`





