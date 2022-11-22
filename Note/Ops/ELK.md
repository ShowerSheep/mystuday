# ELK

### 1. 版本说明

相应的版本最好下载对应的插件

```bash
#Elasticsearch: 6.5.4
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.5.4.tar.gz

#Logstash: 6.5.4
wget https://artifacts.elastic.co/downloads/logstash/logstash-6.5.4.tar.gz

#Kibana: 6.5.4
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.5.4-linux-x86_64.tar.gz
```

相关地址：

官网地址：https://www.elastic.co

官网搭建：https://www.elastic.co/guide/index.html

## 1、Elasticsearch部署

### 1. 安装jdk8

版本6对应jdk8

```bash
tar xf jdk-8u311-linux-x64.tar.gz -C /usr/local/

cat >> /etc/profile.d/jdk.sh <<EOF
export JAVA_HOME=/usr/local/jdk1.8.0_311
export JRE_HOME=\${JAVA_HOME}/jre
export CLASSPATH=.:\${JAVA_HOME}/lib:\${JRE_HOME}/lib
export PATH=\${JAVA_HOME}/bin:\$PATH
EOF

source /etc/profile
```

### 2. 安装配置ES

只在第一台操作操作下面的部分

#### (1) 创建ES普通用户

```bash
useradd elsearch
echo "123456" | passwd --stdin "elsearch"
```

> 如果是集群三台机器都要操作

#### (2) 安装配置ES

```bash
tar xf elasticsearch-6.5.4.tar.gz
mv elasticsearch-6.5.4 /usr/local/elasticsearch

cd /usr/local/elasticsearch/config
cp elasticsearch.yml elasticsearch.yml.bak
```

修改配置文件 `elasticsearch.yml`

```yaml
cluster.name: elk
node.name: elk01
node.master: true
node.data: true
path.data: /data/elasticsearch/data
path.logs: /data/elasticsearch/logs
bootstrap.memory_lock: false
bootstrap.system_call_filter: false
network.host: 0.0.0.0
http.port: 9200
transport.tcp.port: 9300
http.cors.enabled: true
http.cors.allow-origin: "*"
```

配置项含义：

```yaml
cluster.name        集群名称，各节点配成相同的集群名称。
cluster.initial_master_nodes 集群ip，默认为空，如果为空则加入现有集群，第一次需配置
node.name       节点名称，各节点配置不同。
node.master     指示某个节点是否符合成为主节点的条件。
node.data       指示节点是否为数据节点。数据节点包含并管理索引的一部分。
path.data       数据存储目录。
path.logs       日志存储目录。
bootstrap.memory_lock       
bootstrap.system_call_filter
network.host    绑定节点IP。
http.port       端口。
transport.tcp.port  集群内部tcp连接端口
discovery.seed_hosts    提供其他 Elasticsearch 服务节点的单点广播发现功能，这里填写除了本机的其他ip
discovery.zen.minimum_master_nodes  集群中可工作的具有Master节点资格的最小数量，具有master资格的节点的数量。
discovery.zen.ping_timeout      节点在发现过程中的等待时间。
discovery.zen.fd.ping_retries        节点发现重试次数。
http.cors.enabled              用于允许head插件访问ES。
http.cors.allow-origin              允许的源地址。
```

#### (3) 设置JVM堆大小

如果是集群三台都要操作

```bash
vim jvm.options
```

> `-Xms1g` ----修改成 `-Xms2g`
> `-Xmx1g` ----修改成 `-Xms2g`
>
> 或
>
> ```bash
> sed -i 's/-Xms1g/-Xms2g/' /usr/local/elasticsearch/config/jvm.options
> sed -i 's/-Xmx1g/-Xmx2g/' /usr/local/elasticsearch/config/jvm.options
> ```

注意

确保堆内存最小值（Xms）与最大值（Xmx）的大小相同，防止程序在运行时改变堆内存大小。
堆内存大小不要超过系统内存的50%

#### (4) 创建ES数据及日志存储目录，修改权限

```bash
mkdir -p /data/elasticsearch/{data,logs}
chown -R elsearch:elsearch /data/elasticsearch /usr/local/elasticsearch/
```

### 3. 系统优化

#### (1) 增加最大文件打开数

永久生效方法

```bash
echo "* - nofile 65536" >> /etc/security/limits.conf
```

#### (2) 增加最大进程数

```bash
vim /etc/security/limits.d/20-nproc.conf

#添加
*          soft    nproc     65536
*          hard    nproc     65536
*          soft    nofile    65536
*          hard    nofile    65536
```

#### (3) 增加最大内存映射数

```bash
vim /etc/sysctl.conf

#添加
vm.max_map_count=262144
vm.swappiness=0
```

```bash
sysctl -p
```

启动如果报下列错误

```
memory locking requested for elasticsearch process but memory is not locked
elasticsearch.yml文件
bootstrap.memory_lock : false
/etc/sysctl.conf文件
vm.swappiness=0

错误:
max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]

意思是elasticsearch用户拥有的客串建文件描述的权限太低，知道需要65536个

解决：
切换到root用户下面，
vim   /etc/security/limits.conf

在最后添加
* hard nofile 65536
* hard nofile 65536
启动还会遇到另外一个问题，就是
max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
意思是：elasticsearch用户拥有的内存权限太小了，至少需要262114。这个比较简单，也不需要重启，直接执行
# sysctl -w vm.max_map_count=262144
就可以了
```

### 4. 启动ES

```bash
su - elsearch
cd /usr/local/elasticsearch/
./bin/elasticsearch
```

先启动看看是否报错，需要多等一会

终止执行

```bash
#放后台启动
nohup ./bin/elasticsearch &

#看一下是否启动
tail -f nohup.out
#或者
su - elsearch -c "nohup /usr/local/elasticsearch/bin/elasticsearch &>/usr/local/elasticsearch/es.log &"
```

测试：浏览器访问 `192.168.155:9200`

显示

```json
{
  "name" : "elk01",
  "cluster_name" : "elk",
  "cluster_uuid" : "0x4BIGHpTsSENNhzFKCyKg",
  "version" : {
    "number" : "6.5.4",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "d2ef93d",
    "build_date" : "2018-12-17T21:17:40.758843Z",
    "build_snapshot" : false,
    "lucene_version" : "7.5.0",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

> 9200与9300端口号的区别：
>
> 9300端口： ES节点之间通讯使用，是TCP协议端口号，ES集群之间通讯端口号。
> 9200端口： ES节点和外部通讯使用，暴露接口端口号。浏览器访问时使用

### 5. 安装配置es-head监控插件(可选)

#### (1) 安装node

```bash
wget https://npm.taobao.org/mirrors/node/v14.15.3/node-v14.15.3-linux-x64.tar.gz
tar xzvf node-v14.15.3-linux-x64.tar.gz
mv node-v14.15.3-linux-x64 /usr/local/node

cat >>/etc/profile.d/node.sh<<EOF
NODE_HOME=/usr/local/node
export PATH=\$NODE_HOME/bin:\$PATH
EOF
source /etc/profile
node -v
```

#### (2) 下载head插件

```bash
wget https://github.com/mobz/elasticsearch-head/archive/master.zip
unzip -d /usr/local/ master.zip
cd /usr/local

#或者
unzip –d /usr/local elasticsearch-head-master.zip
```

#### (3) 安装grunt

```bash
cd /usr/local/elasticsearch-head-master

#更换淘宝镜像源
npm config set registry https://registry.npm.taobao.org

npm install -g grunt-cli

#检查grunt版本号
grunt --version
```

#### (4) 修改head源码

```bash
vim /usr/local/elasticsearch-head-master/Gruntfile.js
```

95行，添加hostname，注意在上一行末尾添加逗号,hostname 不需要添加逗号

```json
connect: {
    server: {
        options: {
            port: 9100,
            base: '.',
            keepalive: true,
            hostname: '*'
        }
    }
}
```

#### (5) 下载head必要的文件

```bash
wget https://github.com/Medium/phantomjs/releases/download/v2.1.1/phantomjs-2.1.1-linux-x86_64.tar.bz2
yum -y install bzip2
tar -jxf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /tmp/
```

#### (6) 运行head

```bash
cd /usr/local/elasticsearch-head-master/

#换淘宝镜像源
npm config set registry https://registry.npm.taobao.org

npm install

#如果报错执行
npm install phantomjs-prebuilt@2.1.16 --ignore-scripts

nohup grunt server &
```

#### (7) 测试

访问 `192.168.1.155:9100`

![image-20221103170426262](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221103170426262.png)



#### (8) ES 开机启动脚本

```bash
touch /usr/local/elasticsearch/start.sh && chmod o+x /usr/local/elasticsearch/start.sh
chown -R elsearch:elsearch /usr/local/elasticsearch/start.sh

vim /usr/local/elasticsearch/start.sh
```

```sh
#!/bin/bash
/usr/bin/su - elsearch -c "nohup /usr/local/elasticsearch/bin/elasticsearch  &>/usr/local/elasticsearch/es.log &"
```



#### (9) es监控启动脚本

```bash
#启动脚本
touch /usr/local/elasticsearch-head-master/start.sh 
chmod o+x /usr/local/elasticsearch-head-master/start.sh

vim /usr/local/elasticsearch-head-master/start.sh
```

```sh
#!/bin/bash
cd /usr/local/elasticsearch-head-master && nohup grunt server &>/usr/local/elasticsearch-head-master/es-head.log &
```



#### (10) 开机自启

```bash
chmod +x /etc/rc.d/rc.local
vim /etc/rc.local

/bin/bash /usr/local/elasticsearch/start.sh
/bin/bash /usr/local/elasticsearch-head-master/start.sh

source  /etc/profile
systemctl enable rc-local
```



## 2、Kibana布署

### 1. 安装配置Kibana

#### (1) 安装

```bash
tar zvxf kibana-6.5.4-linux-x86_64.tar.gz
mv kibana-6.5.4-linux-x86_64 /usr/local/kibana
```

#### (2) 配置

```bash
cd /usr/local/kibana/config/

vim kibana.yml

server.port: 5601
server.host: "192.168.1.155"
elasticsearch.url: "http://192.168.1.155:9200"
kibana.index: ".kibana"
```

配置含义

```yml
server.port kibana服务端口，默认5601
server.host kibana主机IP地址，默认localhost
elasticsearch.hosts   用来做查询的ES节点的URL，默认http://localhost:9200
kibana.index        kibana在Elasticsearch中使用索引来存储保存
dashboards，默认.kibana
```

#### (3) 启动

```bash
nohup /usr/local/kibana/bin/kibana &>/usr/local/kibana/kibana.log &

#启动脚本
cat >>/usr/local/kibana/start.sh <<EOF
#!/bin/bash
nohup /usr/local/kibana/bin/kibana &>/usr/local/kibana/kibana.log &
EOF

#开机自启
chmod +x /etc/rc.d/rc.local

cat >>/etc/rc.local<<EOF
/bin/bash /usr/local/kibana/start.sh
EOF

systemctl enable rc-local
```

#### (4) 访问

访问 `192.168.1.155:5601`

![image-20221103172600304](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221103172600304.png)



## 3、Logstash部署

logstash用于在收集(inputs)客户端日志，并导出到es中

过程: 通过nginx的访问日志获取日志--->传输到logstach ----传输到--elasticsearch--传输到---kibana

另一台服务器

#### (0) 安装nginx配置日志输出格式

将原来的日志格式注释掉定义成json格式,引用定义的json格式的日志

```nginx
log_format  json '{"@timestamp":"$time_iso8601",'
                           '"@version":"1",'
                           '"client":"$remote_addr",'
                           '"url":"$uri",'
                           '"status":"$status",'
                           '"domain":"$host",'
                           '"host":"$server_addr",'
                           '"size":$body_bytes_sent,'
                           '"responsetime":$request_time,'
                           '"referer": "$http_referer",'
                           '"ua": "$http_user_agent"'
               '}';
access_log  /var/log/nginx/access_json.log  json;
```

创建日志文件

```bash
mkdir -p /var/log/nginx
touch /var/log/nginx/access_json.log
```

浏览器多访问几次

#### (1) 安装配置Logstash

安装jdk8，略

```bash
tar xf logstash-6.5.4.tar.gz

mv logstash-6.5.4 /usr/local/logstash

cat >>/etc/profile.d/logstash.sh<<EOF
export PATH=/usr/local/logstash/bin:\$PATH
EOF

source /etc/profile
```

#### (2) 配置 logstash

```bash
##定义收集日志端
mkdir -p /usr/local/logstash/etc/conf.d

cat >>/usr/local/logstash/etc/conf.d/input.conf<<EOF
input{
#让logstash可以读取特定的事件源。
   file{ 
   #从文件读取
   path => ["/var/log/nginx/access_json.log"] 
   #要输入的文件路径
   type => "shopweb" 
   #定义一个类型，通用选项. 
   }
}
EOF

##定义输出端为es
cat >>/usr/local/logstash/etc/conf.d/output.conf<<EOF
output{
#输出插件，将事件发送到特定目标
    elasticsearch {
    #输出到es
    hosts => ["10.36.107.10:9200"]
    #指定es服务的ip加端口
    index => ["%{type}-%{+YYYY.MM.dd}"]
    #引用input中的type名称，定义输出的格式
    }
}
EOF
```

#### (3) 启动logstash

手工启动

```bash
nohup logstash -f /usr/local/logstash/etc/conf.d/ --config.reload.automatic &>/usr/local/logstash/logstash.log &
```

开机自启

```bash
chmod +x /etc/rc.d/rc.local

echo 'nohup /usr/local/logstash/bin/logstash -f /usr/local/logstash/etc/conf.d/ --config.reload.automatic &>/usr/local/logstash/logstash.log &' >> /etc/rc.local

systemctl enable rc-local
```

#### (4) ES中查看

访问 `192.168.1.155:9100`

#### (5) Kibana 中展示

访问 `192.168.1.155:5601`

## 4、filebeat部署(推荐)

客户端使用filebeat收采日志

IP：192.168.1.156

web服务:nginx

### 0. 安装nginx配置日志输出格式

注释掉原本的日志格式

```nginx
#    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
#                      '$status $body_bytes_sent "$http_referer" '
#                      '"$http_user_agent" "$http_x_forwarded_for"';
#    access_log  logs/access.log  main;

log_format  json '{"@timestamp":"$time_iso8601",'
                           '"@version":"1",'
                           '"client":"$remote_addr",'
                           '"url":"$uri",'
                           '"status":"$status",'
                           '"domain":"$host",'
                           '"host":"$server_addr",'
                           '"size":$body_bytes_sent,'
                           '"responsetime":$request_time,'
                           '"referer": "$http_referer",'
                           '"ua": "$http_user_agent"'
               '}';
access_log  /var/log/nginx/access_json.log  json;
```

```bash
nginx -s reload
```

浏览器多访问几次，产生日志

查看日志输出

```bash
cat /var/log/nginx/access_json.log
```



### 1. 安装布署 filebeat

```bash
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.5.4-x86_64.rpm
rpm -ivh filebeat-6.5.4-x86_64.rpm
```

### 2. 服务自启

```bash
systemctl enable filebeat
```

### 3. 修改配置

```bash
vim /etc/filebeat/filebeat.yml
```

注意排版，yml有两个空格对齐

```yaml
filebeat.inputs:
- type: log
   enabled: true
   paths:
     - /var/log/nginx/access_json.log
output.elasticsearch:
  hosts: ["192.168.1.155:9200"]
  index: "filebeat-nginx-web-%{+yyyy.MM.dd}"
setup.template.name: "filebeat-nginx-web"
setup.template.pattern: "filebeat-nginx-web-*"
```

参数说明

```yaml
参数说明
filebeat.inputs:
- type: log
   enabled: true
   #启用inputs
   paths:
     - /var/log/nginx/access_json.log
   #日志文件路径
output.elasticsearch:
#output为es
  hosts: ["192.168.1.155:9200"] 
  #es地址
  index: "filebeat-nginx-web-%{+yyyy.MM.dd}"
  ##使用自定义索引名称为filebeat-nginx-web-年.月.日
setup.template.name: "filebeat-nginx-web"
#自定义索引名称filebeat-nginx-web
setup.template.pattern: "filebeat-nginx-web-*"
#自定义索引匹配符
```

### 4. 启动服务

```bash
systemctl start filebeat
```

### 5. Kibana 中展示

访问 `192.168.1.155:5601`

### 6. 添加索引

索引名：filebeat-nginx-web-*



## 5、filebeat输出到redis

使用filebeat将日志输出到redis缓存中，再用logstash导入redis中的记录，导出至es中，使用kibana展现。

### 0. 环境参数

> 192.168.1.157	redis
>
> 192.168.1.156	web(nginx) 、filebeat
>
> 192.168.1.155	logstash、 ES、 kibana
>
> 说明:logstash可与es,kibana一起部署，也可以分开部署

### 1. 环境准备

logstash与ES、kibana分离布署

### 2. redis安装

```bash
wget http://download.redis.io/releases/redis-4.0.9.tar.gz
tar xzf redis-4.0.9.tar.gz
cd redis-4.0.9/

yum install -y gcc make
make PREFIX=/usr/local/redis  install
cp redis.conf  /usr/local/redis
```



### 3. web 服务器

安装nginx，配置日志输出格式

```ngixn
#    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
#                      '$status $body_bytes_sent "$http_referer" '
#                      '"$http_user_agent" "$http_x_forwarded_for"';
#    access_log  logs/access.log  main;

log_format  json '{"@timestamp":"$time_iso8601",'
                           '"@version":"1",'
                           '"client":"$remote_addr",'
                           '"url":"$uri",'
                           '"status":"$status",'
                           '"domain":"$host",'
                           '"host":"$server_addr",'
                           '"size":$body_bytes_sent,'
                           '"responsetime":$request_time,'
                           '"referer": "$http_referer",'
                           '"ua": "$http_user_agent"'
               '}';
access_log  /var/log/nginx/access_json.log  json;
```

### 4. 安装filebeat

1、安装filebeat

```bash
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.5.4-x86_64.rpm
rpm -ivh filebeat-6.5.4-x86_64.rpm
```

2、服务自启

```bash
systemctl enable filebeat
```

### 5. 修改配置

```bash
vim /etc/filebeat/filebeat.yml
```

注意排版,yml格式有2个空格对齐

```yaml
filebeat.inputs:
- type: log
   enabled: true
   paths:
     - /var/log/nginx/access_json.log
output.redis:
  hosts: ["192.168.1.157:6379"]
  #password: "123456"
  key: "filebeat-redis-web"
  db: 0
  timeout: 5
  ##ttl过期
```

### 6. 重启服务

```bash
systemctl restart filebeat
```

### 7. 访问web服务

按ctrl+f5刷新，产生访问日志

### 8. 查看filebeat日志

```bash
tail -f /var/log/filebeat/filebeat
```

### 9. 查看redis缓存



### 10. 配置logstash

```bash
vim /usr/local/logstash/etc/conf.d/redis.conf
```

```redis
input { 
  redis {
    data_type => "list"
    key => "filebeat-redis-web"
    #redis中的键值，与filebeat中output.redis中的key: "filebeat-redis-web"，保持一致
    host => "192.168.1.157"
    port => "6379"
    db => "0"
  }
}
output {
    elasticsearch {
    hosts => "http://192.168.1.155:9200"
    manage_template => false
    index => ["filebeat-redis-web"]
    } 
}   
```

### 11. 启动logstash

```bash
nohup /usr/local/logstash/bin/logstash -f /usr/local/logstash/etc/conf.d/ --config.reload.automatic &>/usr/local/logstash/logstash.log &
```

> 当logstash启动以后，将redis中的缓存转存至es中，redis中的缓存记录将失效

### 12. ES 中查看索引





