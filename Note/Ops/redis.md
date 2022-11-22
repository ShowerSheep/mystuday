# Redis

## 1. 安装

```bash
wget http://download.redis.io/releases/redis-4.0.9.tar.gz
tar xzf redis-4.0.9.tar.gz
cd redis-4.0.9

yum install -y gcc make
make PREFIX=/usr/local/redis  install

cp redis.conf  /usr/local/redis
```

> 注：如果报错请将刚才解压的安装包删除掉，再次重新解压并进行make安装即可。

修改配置文件

```bash
cd /usr/local/redis/
vim redis.conf
```

```redis
bind 0.0.0.0　　#只监听所有接口或监听内网IP
daemonize yes　 #开启后台模式将no改为yes
port 6379       #端口号
```

配置环境变量

```bash
echo "export PATH=\$PATH:/usr/local/redis/bin" >> ~/.bashrc

source ~/.bashrc
```

添加系统服务

```bash
cat >/usr/lib/systemd/system/redis.service<<EOF
[Unit]
Description=The redis-server Process Manager
After=syslog.target network.target

[Service]
Type=simple
PIDFile=/var/run/redis_6379.pid
ExecStartPost=/bin/sleep 0.1
ExecStart=/usr/local/redis/bin/redis-server  /usr/local/redis/redis.conf
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStop=/bin/kill -s QUIT \$MAINPID

[Install]
WantedBy=multi-user.target
EOF
```

```bash
systemctl daemon-reload
systemctl enable redis
systemctl start redis
```

## 2. 登录

```bash
redis-cli  -h 127.0.0.1 -p 6379

ping
```

## 3. redis 相关工具

```bash
./redis-cli           #redis的客户端
./redis-server        #redis的服务端
./redis-check-aof     #用于修复出问题的AOF文件
./redis-sentinel      #用于哨兵管理
```

## 4. redis 操作

`string` 字符串类型

string 是 redis 最基本的类型，一个 key 对应一个 value。

```redis
set name xiaoming
#设置key--name，并设置值--（string类型）
get name
#获取到key
```

`set` 集合

Redis的Set是string类型的无序集合。
添加一个 string 元素到 key 对应的 set 集合中，成功返回1，如果元素已经在集合中返回 0，如果 key 对应的 set 不存在则返回错误。

```redis
sadd myset redis
sadd myset zabbix
sadd myset rabbitmq

smembers myset
```

 ![image-20221028170809619](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221028170809619.png)

插入两次数据

 ![image-20221028170900453](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221028170900453.png)

> 注意：以上实例中 redis 添加了两次，但根据集合内元素的唯一性，第二次插入的元素将被忽略。

查看 `key` 的类型

```redis
type myset
type name
```

 ![image-20221028171049888](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221028171049888.png)

查看所有的`key`

```redis
keys *
```

删除某个`key`

```redis
del myset
```



## 5. 数据持久化

即把数据保存到可永久保存的存储设备中（如磁盘）。

### 1.redis持久化 2 种方法

redis提供了两种持久化的方式，分别是RDB（Redis DataBase）和AOF（Append Only File）。

> RDB（Redis DataBase）：是在不同的时间点，将redis存储的数据生成快照并存储到磁盘等介质上；
> 特点:
> 1.周期性
> 2.不影响数据写入  #RDB会启动子进程，备份所有数据。当前进程，继续提供数据的读写。当备份完成，才替换老的备份文件。
> 3.高效     #一次性还原所有数据
> 4.完整性较差 #由于拍快照是有周期性的，当拍快照时发生故障了，所以恢复到故障点到上一次的备份，到下次备份之间的数据无法恢复。

> AOF（Append Only File）则是换了一个角度来实现持久化，那就是将redis执行过的所有写指令记录下来，在下次redis重新启动时，只要把这些写指令从前到后再重复执行一遍，就可以实现数据恢复了。
> 特点:
> 1.实时性
> 2.完整性较好
> 3.体积大  #记录数据的指令，删除数据的指令都会被记录下来。

RDB和AOF两种方式也可以同时使用，在这种情况下，如果redis重启的话，则会优先采用AOF方式来进行数据恢复，这是因为AOF方式的数据恢复完整度更高。

> 如何选择方式？
>
> 缓存：不用开启任何持久方式
> 双开: 因RDB数据不实时，但同时使用两者时服务器只会找AOF文件,所以RDB留作万一的手段。
> 官方的建议是两个同时使用。这样可以提供更可靠的持久化方案。
> 写入速度快 ------------AOF
> 写入速度慢 ------------RDB

### 2. 持久化配置

1、RDB默认开启

创建持久化目录

```bash
mkdir -p /data/redis/cache_data
```

2、编辑配置文件

```bash
vim /usr/local/redis/redis.conf
```

```redis
#dbfilename：持久化数据存储在本地的文件
dbfilename dump.rdb

#dir：持久化数据存储在本地的路径
dir /data/redis/cache_data

##snapshot触发的时机，save <seconds> <changes>  
##如下为900秒后，至少有一个变更操作，才会snapshot  
##对于此值的设置，需要谨慎，评估系统的变更操作密集程度  
##可以通过save “”来关闭snapshot功能  
#save时间，以下分别表示更改了1个key时间隔900s进行持久化存储；更改了10个key300s进行存储；更改10000个key60s进行存储。
save 900 1
save 300 10
save 60 10000 

##yes代表当使用bgsave命令持久化出错时候停止写RDB快照文件,no表明忽略错误继续写文件，“错误”可能因为磁盘已满/磁盘故障/OS级别异常等  
stop-writes-on-bgsave-error yes

##是否启用rdb文件压缩，默认为“yes”，压缩往往意味着“额外的cpu消耗”，同时也意味着较短的网络传输时间  
rdbcompression yes 
```

3、AOF默认关闭 --> 开启

```bash
vim /usr/local/redis/redis.conf
```

修改：`appendonly yes`

1、此选项为aof功能的开关，默认为“no”，可以通过“yes”来开启aof功能,只有在“yes”下，aof重写/文件同步等特性才会生效

2、指定aof文件名称

`appendfilename appendonly.aof`

3、指定aof操作中文件同步策略，有三个合法值：always everysec no,默认为everysec

```redis
appendfsync everysec 
always     #每次有数据修改发生时都会写入AOF文件。
everysec  #每秒钟同步一次，该策略为AOF的缺省策略
no          #从不同步。高效但是数据不会被持久化
```

 **开启持久化功能后，重启redis后，数据会自动通过持久化文件恢复**



## 6. redis 主从配置

主：`192.168.1.155`

从：`192.168.1.156`

1、编辑master配置文件

```bash
cd /usr/local/redis/
vim redis.conf
```

```redis
protected-mode no
```

关闭protected-mode模式，此时任意ip可以直接访问
开启protected-mode保护模式，需配置bind ip或者设置访问密码

2、修改slave配置文件

```redis
bind 0.0.0.0
protected-mode no
slaveof 192.168.1.155 6379
#添加master的内网IP和端口
```

3、重启redis

```bash
systemctl restart redis
```

4、测试主从

主：

 ![image-20221028175047133](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221028175047133.png)

```redis
info replication
```

 ![image-20221028175327294](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221028175327294.png)

从：

 ![image-20221028175102775](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221028175102775.png)

```redis
info replication
```

 ![image-20221028175353374](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221028175353374.png)



## 7. redis-sentinel---哨兵模式

1、每台机器上修改redis主配置文件redis.conf文件设置：bind 0.0.0.0

2、每台机器上修改`sentinel.conf`配置文件：修改如下配置

```bash
/usr/local/redis/sentinel.conf
```

```redis
sentinel monitor mymaster 192.168.1.155 6379 2 
#当集群中有2个sentinel认为master死了时，才能真正认为该master已经不可用了。 (slave上面写的是master的ip，master写自己ip)
sentinel down-after-milliseconds mymaster 3000 
#单位毫秒
sentinel failover-timeout mymaster 10000
#若sentinel在该配置值内未能完成failover(故障转移)操作（即故障时master/slave自动切换），则认为本次failover失败。
protected-mode no
#关闭加密模式
logfile "/usr/local/redis/redis-sentinel.log"
#定义日志
pidfile "/var/run/redis-sentinel.pid"
#定义PID文件
```

```redis
sentinel monitor mymaster 192.168.1.155 6379 2
sentinel down-after-milliseconds mymaster 3000
sentinel failover-timeout mymaster 10000
protected-mode no
logfile "/usr/local/redis/redis-sentinel.log"
pidfile "/var/run/redis-sentinel.pid"
```

3、每台机器后台启动哨兵服务

```bash
nohup  /usr/local/redis/bin/redis-sentinel  /usr/local/redis/sentinel.conf &>/usr/local/redis/redis-sentinel.log &
```

查看日志

```bash
tail -f /usr/local/redis/redis-sentinel.log
```

4、测试

将master的哨兵模式退出，再将redis服务stop了，在两台slave上面查看其中一台是否切换为master:(没有优先级，为选举切换)

```bash
redis-cli info replication
```

并且检查同步情况

## 8. redis主从+哨兵+keepalived高可用

### 1. 环境说明

主：192.168.1.155

从：192.168.1.156、192.168.1.157

### 2. 关键参数

主：

添加master同步认证

```redis
bind 0.0.0.0
protected-mode no

masterauth "123.com"
requirepass "123.com"
```

从：

```redis
bind 0.0.0.0
protected-mode no

slaveof 192.168.1.155 6379
masterauth "123.com"
requirepass "123.com"
```

### 3. 哨兵配置

3台相同

```bash
cat >/usr/local/redis/sentinel.conf<<EOF
sentinel monitor mymaster 192.168.1.155 6379 1 
sentinel down-after-milliseconds mymaster 3000 
sentinel failover-timeout mymaster 10000
sentinel auth-pass mymaster 123.com
protected-mode no
logfile "/usr/local/redis/redis-sentinel.log"
EOF
```

### 4. 后台启动哨兵服务脚本

3台都要

```bash
vim /usr/local/redis/start.sh
```

脚本内容

```sh
#!/bin/bash
/usr/bin/nohup  /usr/local/redis/bin/redis-sentinel  /usr/local/redis/sentinel.conf &>/usr/local/redis/redis-sentinel.log &
```

```bash
vim /usr/local/redis/stop.sh
```

脚本内容

```sh
#!/bin/bash
ps aux | grep redis-sentinel | grep -v grep | awk '{print $2}' | xargs kill &>/dev/null
```

### 5. 开机自启

```bash
/usr/local/redis/start.sh
chmod +x /etc/rc.d/rc.local 
cat >>/etc/rc.local<<EOF
/bin/bash /usr/local/redis/start.sh
EOF
systemctl enable rc-local
systemctl enable redis
```

### 6. 查看主从同步状态

```bash
redis-cli -a 123.com info replication
```

 ![image-20221029141417845](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221029141417845.png)

 ![image-20221029141433108](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221029141433108.png)

 ![image-20221029141448923](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221029141448923.png)



### 7. 安装keepalived

```bash
yum -y install libnl libnl-devel libnfnetlink-devel openssl opssl-devel

tar xzvf keepalived-2.0.0.tar.gz && cd keepalived-2.0.0

./configure  --prefix=/usr/local/keepalived
make && make install

ln -s /usr/local/keepalived/sbin/keepalived /usr/sbin/keepalived
cp /usr/local/keepalived/etc/sysconfig/keepalived /etc/sysconfig/

mkdir -p /etc/keepalived/
cp /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived/

cp keepalived/etc/init.d/keepalived /etc/init.d/
chkconfig  --add keepalived
chmod o+x /etc/init.d/keepalived
chkconfig  keepalived on

systemctl enable keepalived
```

### 8. 配置keepalived

3台都要：

```bash
vim /etc/keepalived/check.sh
chmod +x /etc/keepalived/check.sh
```

```sh
#!/bin/bash
num=`/usr/local/redis/bin/redis-cli -a 123.com info | grep role:master | wc -l`
sleep 1
if [ "$num" = "1" ]; then
   echo "`date +%F_%T`_redis_status:master" >>/root/status.log
else
   exit 1
fi
```

master-A：

```keepalived
global_defs {
    router_id NodeA
    script_user root
    enable_script_security
}
vrrp_script chk_redis_master {
    script "/etc/keepalived/check.sh"
    interval 3
    weight -20
}
vrrp_instance VI_1 {
    state MASTER
    interface ens33
    virtual_router_id 35
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass Pass1234
    }
    virtual_ipaddress {
        192.168.1.100 dev ens33 label ens33:0
    }
    track_script {
        chk_redis_master
    }
}
```

slave-B：

```keepalived
global_defs {
    router_id NodeB
    script_user root
    enable_script_security
}
vrrp_script chk_redis_master {
    script "/etc/keepalived/check.sh"
    interval 3
    weight -20
}
vrrp_instance VI_1 {
    state BACKUP
    interface ens33
    virtual_router_id 35
    priority 95
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass Pass1234
    }
    virtual_ipaddress {
        192.168.1.100 dev ens33 label ens33:0
    }
    track_script {
        chk_redis_master
    }
}
```

slave-C：

```keepalived
global_defs {
    router_id NodeC
    script_user root
    enable_script_security
}
vrrp_script chk_redis_master {
    script "/etc/keepalived/check.sh"
    interval 3
    weight -20
}
vrrp_instance VI_1 {
    state BACKUP
    interface ens33
    virtual_router_id 35
    priority 90
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass Pass1234
    }
    virtual_ipaddress {
        192.168.1.100 dev ens33 label ens33:0
    }
    track_script {
        chk_redis_master
    }
}
```

### 9. 测试

全部打开 `keepalived` 服务

```bash
systemctl start keepalived
```

关闭master，查看哨兵切换主从，同时查看ip是否飘移

例

`slave-C` 切换为主，ip飘移到C

使用客户端工具连接 `192.168.1.100` 测试。



## 9. Redis Cluster集群

### 1. 集群布署

> redis-cluster1: 192.168.1.156  7000、7001
> redis-cluster2: 192.168.1.157   7002、7003
> redis-cluster3: 192.168.1.158   7004、7005

#### 1、安装redis

```bash
wget https://download.redis.io/releases/redis-6.2.0.tar.gz
tar xzvf redis-6.2.0.tar.gz
cd redis-6.2.0/
yum install -y gcc make
make PREFIX=/usr/local/redis  install
mkdir -p /data/redis/data
#创建存放数据的目录

echo "export PATH=/usr/local/redis/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc
```

#### 2、创建节点目录

```bash
# 1.
mkdir -p /data/redis/cluster/700{0,1}

# 2.
mkdir -p /data/redis/cluster/700{2,3}

# 3.
mkdir -p /data/redis/cluster/700{4,5}
```

#### 3、分别修改集群每个redis配置文件

1.

先将解压的redis包里的 `redis.conf` 放到创建的 `7000` 等目录下

```bash
cp ~/redis-6.2.0/redis.conf /data/redis/cluster/7000/

vim /data/redis/cluster/7000/redis.conf
```

修改配置文件

```redis
bind 192.168.1.156  #每个实例的配置文件修改为对应节点的ip地址
port 7000   #监听端口，运行多个实例时，需要指定规划的每个实例不同的端口号
daemonize yes #redis后台运行
pidfile /var/run/redis_7000.pid #pid文件，运行多个实例时，需要指定不同的pid文件
logfile /var/log/redis_7000.log #日志文件位置，运行多实例时，需要将文件修改的不同。
dir /data/redis/data #存放数据的目录
appendonly yes #开启AOF持久化，redis会把所接收到的每一次写操作请求都追加到appendonly.aof文件中，当redis重新启动时，会从该文件恢复出之前的状态。
appendfilename "appendonly.aof"  #AOF文件名称
appendfsync everysec #表示对写操作进行累积，每秒同步一次
以下为打开注释并修改
cluster-enabled yes #启用集群
cluster-config-file nodes-7000.conf #集群配置文件，由redis自动更新，不需要手动配置，运行多实例时请注修改为对应端口
cluster-node-timeout 5000 #单位毫秒。集群节点超时时间，即集群中主从节点断开连接时间阈值，超过该值则认为主节点不可以，从节点将有可能转为master
cluster-replica-validity-factor 10#在进行故障转移的时候全部slave都会请求申请为master。该参数就是用来判断slave节点与master断线的时间是否过长。
cluster-migration-barrier 1 #一个主机将保持连接的最小数量的从机，以便另一个从机迁移到不再被任何从机覆盖的主机
cluster-require-full-coverage yes #集群中的所有slot（16384个）全部覆盖，才能提供服务

#注：
所有节点配置文件全部修改切记需要修改的ip、端口、pid文件...避免冲突。确保所有机器都修改。
分别在7001,7002,7003,7004,7005目录下建立上述配置
```

修改完成之后复制到7001目录下

```bash
cp /data/redis/cluster/7000/redis.conf /data/redis/cluster/7001/
sed -i 's#7000#7001#g' /data/redis/cluster/7001/redis.conf
```

把配置文件拷贝到另外的服务器

```bash
scp redis.conf 192.168.1.157:/data/redis/cluster/7002/

scp redis.conf 192.168.1.158:/data/redis/cluster/7004/
```

2.

```bash
sed -i 's#bind 192.168.1.156#bind 192.168.1.157#g' /data/redis/cluster/7002/redis.conf

sed -i 's#7000#7002#g' /data/redis/cluster/7002/redis.conf

cp /data/redis/cluster/7002/redis.conf /data/redis/cluster/7003/

sed -i 's#7002#7003#g' /data/redis/cluster/7002/redis.conf
```

3.

```bash
sed -i 's#bind 192.168.1.156#bind 192.168.1.158#g' /data/redis/cluster/7004/redis.conf

sed -i 's#7000#7004#g' /data/redis/cluster/7004/redis.conf

cp /data/redis/cluster/7004/redis.conf /data/redis/cluster/7005/

sed -i 's#7004#7005#g' /data/redis/cluster/7005/redis.conf
```

#### 4、启动三台机器上面的每个节点

```bash
# 1.
redis-server  /data/redis/cluster/7000/redis.conf
redis-server  /data/redis/cluster/7001/redis.conf

# 2.
redis-server  /data/redis/cluster/7002/redis.conf
redis-server  /data/redis/cluster/7003/redis.conf

# 3.
redis-server  /data/redis/cluster/7004/redis.conf
redis-server  /data/redis/cluster/7005/redis.conf
```

#### 5、查看端口

```bash
netstat -ntpl
```

查看三台服务器的redis服务的端口 `7000-7005` 是否都已启用

#### 6、创建集群

在3台服务器种任意一台

```bash
redis-cli \
--cluster create  \
--cluster-replicas 1 \
192.168.1.156:7000 192.168.1.156:7001 \
192.168.1.157:7002 192.168.1.157:7003 \
192.168.1.158:7004 192.168.1.158:7005
```

1.

```bash
redis-cli -h 192.168.1.156 -c -p 7000
# 是否成功连接

cluster info

cluster nodes
```

![image-20221031171130318](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221031171130318.png)

参数解释：

> runid: 该行描述的节点的id。
> ip:prot: 该行描述的节点的ip和port
> flags: 分隔的标记位，可能的值有：
> 1.master: 该行描述的节点是master
> 2.slave: 该行描述的节点是slave
> 3.fail?:该行描述的节点可能不可用
> 4.fail:该行描述的节点不可用（故障）
> master_runid: 该行描述的节点的master的id,如果本身是master则显示-
> ping-sent: 最近一次发送ping的Unix时间戳，0表示未发送过
> pong-recv：最近一次收到pong的Unix时间戳，0表示未收到过
> config-epoch: 主从切换的次数
> link-state: 连接状态，connnected 和 disconnected
> hash slot: 该行描述的master中存储的key的hash的范围

### 2. 集群操作

1.

```bash
redis-cli -h 192.168.1.156 -c -p 7000
set name yang
get name
```

 ![image-20221031174435898](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221031174435898.png)

 ![image-20221031174506159](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221031174506159.png)

2.

 ![image-20221031174548046](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221031174548046.png)



... ...

测试主从同步情况



## 10. nginx 安装第三方缓存清理模块

### 1. 本机布署redis



### 2. 安装模块 hiredis

```bash
unzip hiredis-master.zip
cd hiredis-master
make
make install
```

> 默认安装位置在/usr/local的lib，与include目录下
>
> 在以下位置产生相关文件/usr/local/include/hiredis，/usr/local/lib 

```bash
ls /usr/local/include/hiredis
ls /usr/local/lib
```

### 3. 安装 redis_nginx_adapter

> 作用：Nginx 的事件结构与 redis 通信，使用 redis 异步上下文。它需要[hiredis](https://github.com/redis/hiredis) >= 0.11.0 和Nginx 头文件。
>
> 获取 Nginx 源代码并使用 ./configure 对其进行配置

```bash
yum install openssl openssl-devel zlib zlib-devel
tar xzvf nginx-1.16.0.tar.gz
cd  /apps/nginx-1.16.0
./configure

cd
unzip redis_nginx_adapter-master.zip

cd redis_nginx_adapter-master
./configure  \
--with-nginx-dir=/root/nginx-1.16.0 \
--with-hiredis-dir=/root/hiredis-master
 
make && make install
 
echo '/usr/local/lib/' >>/etc/ld.so.conf
ldconfig
```

> 在以下位置产生相关文件/usr/local/include/redis_nginx_adapter.h，/usr/local/lib 

```bash
ls /usr/local/include/redis_nginx_adapter.h
ls /usr/local/lib
```

### 4. 安装nginx-selective-cache-purge-module-master

`nginx` 安装并添加模块

```bash
unzip nginx-selective-cache-purge-module-master.zip
unzip ngx_healthcheck_module-master.zip
yum install pcre pcre-devel zlib zlib-devel  patch-y

cd nginx-1.16.0
patch -p1 <../ngx_healthcheck_module-master/nginx_healthcheck_for_nginx_1.16+.patch

./configure --prefix=/usr/local/nginx \
--user=nginx \
--group=nginx \
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
--with-ld-opt='-L/usr/local/lib/ ' \
--with-cc-opt='-I/usr/local/include/ ' \
--add-module=/root/nginx-selective-cache-purge-module-master \
--add-module=/root/ngx_healthcheck_module-master

make && make install

echo "export PATH=\$PATH:/usr/local/nginx/sbin" >> ~/.bashrc
source ~/.bashrc

nginx -V
```

```bash
nginx version: nginx/1.16.0
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC)
built with OpenSSL 1.0.2k-fips  26 Jan 2017
TLS SNI support enabled
configure arguments: --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_stub_status_module --with-http_v2_module --with-http_ssl_module --with-http_gzip_static_module --with-http_realip_module --with-http_flv_module --with-http_mp4_module --with-stream --with-stream_ssl_module --with-stream_realip_module --with-ld-opt=-L/usr/local/lib/ --with-cc-opt=-I/usr/local/include/ --add-module=/root/nginx-selective-cache-purge-module-master --add-module=/root/ngx_healthcheck_module-master
```



### 5. 配置实例

```nginx
user	nginx;
pid         logs/nginx.pid;
error_log   logs/nginx-main_error.log debug;
worker_processes  2;
# Development Mode
master_process      on;
daemon              on;
worker_rlimit_core  500M;
working_directory /tmp;
debug_points abort;

events {
    worker_connections  51200;
    #use                 kqueue; # MacOS
    use                 epoll; # Linux
}

http {
    default_type    application/octet-stream;

    log_format main '["$time_local"] $remote_addr ($status) $body_bytes_sent $request_time $host '
                  '$upstream_cache_status $upstream_response_time '
                  '$http_x_forwarded_for ["$request"] ["$http_user_agent"] ["$http_referer"] ';

    access_log      logs/nginx-http_access.log main;
    error_log       logs/nginx-http_error.log;
    server_tokens off;
 		##反代缓存位置 
    proxy_cache_path /tmp/cache_zone levels=1:2 keys_zone=zone:10m inactive=1m max_size=100m;
    proxy_cache_path /tmp/cache_other_zone levels=1:2 keys_zone=other_zone:1m inactive=10m max_size=10m;
		####redis服务器
    #selective_cache_purge_redis_unix_socket "/tmp/redis.sock";
    selective_cache_purge_redis_host 192.168.1.156;
    selective_cache_purge_redis_port 6379;
    selective_cache_purge_redis_database 4;

    server {
        listen          80;
        server_name     admin.test.com;
    	   #purge清理所有缓存
    	  location ~ /purge(.*) {
           selective_cache_purge_query "$1*";
        }
    		###purge清理指定后缀名的缓存
			location ~ /purge/.*\.(.*)$ {
            selective_cache_purge_query "*$1";
        }
        location / {
        add_header "x-cache-status" $upstream_cache_status;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Range $http_range;
        client_body_buffer_size 2048k;
        proxy_connect_timeout 300;
        proxy_send_timeout 300;
        proxy_read_timeout 300;
        proxy_buffer_size 4k;
        proxy_buffers 4 32k;
        proxy_busy_buffers_size 64k;
        proxy_pass http://192.168.1.111:8080;
        proxy_cache zone;
        proxy_cache_key "$uri";
        proxy_cache_valid 200 2m;
        proxy_cache_use_stale error timeout invalid_header updating http_500;
        }
    }
}
```





