# Keepalived 高可用

## 一、前置

官网：https://keepalived.org/

### 1. 安装

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

### 2. 参数配置

先备份，在编辑

```bash
mv /etc/keepalived/keepalived.conf{,.bak}

vim /etc/keepalived/keepalived.conf
```

主：

```config
global_defs {
   router_id MASTER_133   #定义本机的身份号，需要唯一
}
vrrp_instance VI_1 {  #定义选举组名VI_1，需要唯一，在相同的选举组内进行选举
    state BACKUP      #定义状态MASTER，表示为主
    interface ens33   #定义选举的监听网卡名
    virtual_router_id 1  ##VRID唯一，主备相同
    priority 100        ##定义优先级，优先级高的为MASTER
    advert_int 1      #检查间隔，默认为1s
    authentication {   #定义选举身份验证，主备一致
        auth_type PASS  #定义选举身份验证为密码
        auth_pass 123    #定义选举身份验证密码123.com
    }
    virtual_ipaddress {    #选举产生的群集IP，设备为对外服务的网卡ens33，标记名称ens33:0
        192.168.1.100/24 dev ens33 label ens33:0
    }
}
```

备：

```config
global_defs {
    router_id BACKUP_153   #定义本机的身份号，需要唯一
}
vrrp_instance VI_1 {  #定义选举组名VI_1，需要唯一，在相同的选举组内进行选举
    state BACKUP      #定义状态MASTER，表示为主
    interface ens33   #定义选举的监听网卡名
    virtual_router_id 1  ##VRID唯一，主备相同
    priority 90        ##定义优先级，优先级高的为MASTER
    advert_int 1      #检查间隔，默认为1s
    authentication {   #定义选举身份验证，主备一致
        auth_type PASS  #定义选举身份验证为密码
        auth_pass 123    #定义选举身份验证密码123.com
    }
    virtual_ipaddress {    #选举产生的群集IP，设备为对外服务的网卡ens33，标记名称ens33:0
        192.168.1.100/24 dev ens33 label ens33:0
    }
}
```

### 3. 测试

查看日志和ip

```bash
tail -f /var/log/messages
```

![image-20221021115316308](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221021115316308.png)

 ![image-20221021115348619](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221021115348619.png)

把 `MASTER` 的 `keepalived` 关掉，查看 `BACKUP` 的ip和日志

### 4. 互为主备

![配置对比](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/%E9%85%8D%E7%BD%AE%E5%AF%B9%E6%AF%94.png)

主：

```config
global_defs {
   router_id MASTER_133   #定义本机的身份号，需要唯一
}
vrrp_instance VI_1 {  		#定义选举组名VI_1，需要唯一，在相同的选举组内进行选举
    state MASTER      		#定义状态MASTER，表示为主
    interface ens33   		#定义选举的监听网卡名
    virtual_router_id 1  	##VRID唯一，主备相同
    priority 100        	##定义优先级，优先级高的为MASTER
    advert_int 1      		#检查间隔，默认为1s
    authentication {   		#定义选举身份验证，主备一致
        auth_type PASS  	#定义选举身份验证为密码
        auth_pass 123    	#定义选举身份验证密码123.com
    }
    virtual_ipaddress {    		#选举产生的群集IP，设备为对外服务的网卡ens33，标记名称ens33:0
        192.168.1.100/24 dev ens33 label ens33:0
    }
}
vrrp_instance VI_2 {  		#定义选举组名VI_1，需要唯一，在相同的选举组内进行选举
    state BACKUP      		#定义状态MASTER，表示为主
    interface ens33   		#定义选举的监听网卡名
    virtual_router_id 2  	##VRID唯一，主备相同
    priority 90        		##定义优先级，优先级高的为MASTER
    advert_int 1      		#检查间隔，默认为1s
    authentication {   		#定义选举身份验证，主备一致
        auth_type PASS  		#定义选举身份验证为密码
        auth_pass 123456    	#定义选举身份验证密码123.com
    }
    virtual_ipaddress {    	#选举产生的群集IP，设备为对外服务的网卡ens33，标记名称ens33:0
        192.168.1.101/24 dev ens33 label ens33:1
    }
}
```

备：

```config
global_defs {
   router_id BACKUP_153   		#定义本机的身份号，需要唯一
}
vrrp_instance VI_1 {  		#定义选举组名VI_1，需要唯一，在相同的选举组内进行选举
    state BACKUP      		#定义状态MASTER，表示为主
    interface ens33   		#定义选举的监听网卡名
    virtual_router_id 1  		##VRID唯一，主备相同
    priority 90        		##定义优先级，优先级高的为MASTER
    advert_int 1      		#检查间隔，默认为1s
    authentication {   		#定义选举身份验证，主备一致
        auth_type PASS  		#定义选举身份验证为密码
        auth_pass 123.com    	#定义选举身份验证密码123.com
    }
    virtual_ipaddress {    		#选举产生的群集IP，设备为对外服务的网卡ens33，标记名称ens33:0
        192.168.1.100/24 dev ens33 label ens33:0
    }
}
vrrp_instance VI_2 {  		#定义选举组名VI_1，需要唯一，在相同的选举组内进行选举
    state MASTER      		#定义状态MASTER，表示为主
    interface ens33   		#定义选举的监听网卡名
    virtual_router_id 2  		##VRID唯一，主备相同
    priority 100        		##定义优先级，优先级高的为MASTER
    advert_int 1      		#检查间隔，默认为1s
    authentication {   		#定义选举身份验证，主备一致
        auth_type PASS  		#定义选举身份验证为密码
        auth_pass 123456    	#定义选举身份验证密码123.com
    }
    virtual_ipaddress {    		#选举产生的群集IP，设备为对外服务的网卡ens33，标记名称ens33:0
        192.168.1.101/24 dev ens33 label ens33:1
    }
}
```



### 5. nginx 服务异常时处理

> 当nginx服务异常时，如果不关闭keepalived服务，则无法转发，因此nginx服务异常时，需要关闭本机的keepalived服务，实现服务切换

在两台服务器上操作

```bash
cat >/etc/keepalived/check_nginx.sh<<EOF
#!/bin/bash	        
/usr/bin/curl -I http://localhost &>/dev/null
if [ \$? -ne 0 ];then
systemctl stop keepalived
fi
EOF

chmod o+x /etc/keepalived/check_nginx.sh
```



主：

```config
global_defs {
   router_id MASTER_133   #定义本机的身份号，需要唯一
}
vrrp_script check_nginx {
   script "/bin/bash /etc/keepalived/check_nginx.sh"
   interval 2
   weight -20 			#负表示失败时减权重
}
vrrp_instance VI_1 {  		#定义选举组名VI_1，需要唯一，在相同的选举组内进行选举
    state MASTER      		#定义状态MASTER，表示为主
    interface ens33   		#定义选举的监听网卡名
    virtual_router_id 1  	##VRID唯一，主备相同
    priority 100        	##定义优先级，优先级高的为MASTER
    advert_int 1      		#检查间隔，默认为1s
    authentication {   		#定义选举身份验证，主备一致
        auth_type PASS  	#定义选举身份验证为密码
        auth_pass 123.com    	#定义选举身份验证密码123.com
    }
    virtual_ipaddress {    		#选举产生的群集IP，设备为对外服务的网卡ens33，标记名称ens33:0
        192.168.1.100/24 dev ens33 label ens33:0
    }
    track_script {
        check_nginx
    }
}
vrrp_instance VI_2 {  		#定义选举组名VI_1，需要唯一，在相同的选举组内进行选举
    state BACKUP      		#定义状态MASTER，表示为主
    interface ens33   		#定义选举的监听网卡名
    virtual_router_id 2  	##VRID唯一，主备相同
    priority 90        		##定义优先级，优先级高的为MASTER
    advert_int 1      		#检查间隔，默认为1s
    authentication {   		#定义选举身份验证，主备一致
        auth_type PASS  		#定义选举身份验证为密码
        auth_pass 123456    	#定义选举身份验证密码123.com
    }
    virtual_ipaddress {    	#选举产生的群集IP，设备为对外服务的网卡ens33，标记名称ens33:0
        192.168.1.101/24 dev ens33 label ens33:1
    }
}
```

备：

```config
global_defs {
   router_id BACKUP_153   		#定义本机的身份号，需要唯一
}
vrrp_script check_nginx {
   script "/bin/bash /etc/keepalived/check_nginx.sh"
   interval 2
   weight -20
}
vrrp_instance VI_1 {  		#定义选举组名VI_1，需要唯一，在相同的选举组内进行选举
    state BACKUP      		#定义状态MASTER，表示为主
    interface ens33   		#定义选举的监听网卡名
    virtual_router_id 1  		##VRID唯一，主备相同
    priority 90        		##定义优先级，优先级高的为MASTER
    advert_int 1      		#检查间隔，默认为1s
    authentication {   		#定义选举身份验证，主备一致
        auth_type PASS  		#定义选举身份验证为密码
        auth_pass 123.com    	#定义选举身份验证密码123.com
    }
    virtual_ipaddress {    		#选举产生的群集IP，设备为对外服务的网卡ens33，标记名称ens33:0
        192.168.1.100/24 dev ens33 label ens33:0
    }
}
vrrp_instance VI_2 {  		#定义选举组名VI_1，需要唯一，在相同的选举组内进行选举
    state MASTER      		#定义状态MASTER，表示为主
    interface ens33   		#定义选举的监听网卡名
    virtual_router_id 2  		##VRID唯一，主备相同
    priority 100        		##定义优先级，优先级高的为MASTER
    advert_int 1      		#检查间隔，默认为1s
    authentication {   		#定义选举身份验证，主备一致
        auth_type PASS  		#定义选举身份验证为密码
        auth_pass 123456    	#定义选举身份验证密码123.com
    }
    virtual_ipaddress {    		#选举产生的群集IP，设备为对外服务的网卡ens33，标记名称ens33:0
        192.168.1.101/24 dev ens33 label ens33:1
    }
    track_script {
        check_nginx
    }
}
```

检测：

```bash
systemctl restart keepalived
```

分别访问 `192.168.1.100` 和 `192.168.1.101` 

关闭主服务器的nginx，查看备服务器的ip地址（或**）







