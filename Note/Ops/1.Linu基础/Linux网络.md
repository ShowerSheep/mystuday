# Linux网络

## 一、网络协议

### 1. 通信协议

#### 1、 OSI、TCP\IP参考模型

OSI参考模型	OSI七层模型

TCP/IP参考模型	TCP/IP四层模型

1.OSI七层模型

应用层
表示层
会话层
传输层
网络层
数据链路层
物理层

2.TCP/IP模型

四层模型：

应用层 == 应用层 + 表示层 + 会话层
传输层 == 传输层
网络层 == 网络层
网络接口层 == 数据链路层 + 物理层

五层模型：

应用层 == 应用层 + 表示层 + 会话层
传输层 == 传输层
网络层 == 网络层
数据链路层 == 数据链路层
物理层 == 物理层

广播域：广播所能涉及到的区域

#### 2、数据通信过程

数据封装与解封装的过程

封装的IP报头信息：源IP（SIP）+目的IP （DIP）  客户端的IP  服务器端的IP

数据链路层帧头和帧尾：源MAC + 目的MAC  检测数据完整性

MAC地址  物理地址

MAC地址具有全球唯一性，烧写在网卡上

负责网络内的通信；例如 教室中的网络，可以利用MAC唯一标识一台主机

1.数据封装：

应用层（数据）-->传输层（数据段）-->网络层（数据包）-->数据链路层（数据帧）-->物理层（比特流）

中间经过各种传输介质（双绞线、光纤、同轴电缆、无线...）传输给对方

早上起来一层一层的穿好衣服，才能出门

2.数据解封装：

物理层（接受）-->数据链路层（去掉帧头和帧尾）-->网络层（去掉IP头）-->传输层（去掉tcp头）-->应用层（数据）

3.获取目的MAC：

ARP协议（地址解析协议）

ARP请求：
A会向局域网中所有的主机发送一个广播报文，（询问这个局域网谁是B？）
 接受方的IP地址如果是B的地址，就会接受这个广播报文，如果不是，就会丢弃这个报文

ARP响应：
B主机会将自己的IP地址和MAC地址对应关系发送给A，A接受到这个响应报文后，就获取到了B的MAC
 会将获取到的IP地址和MAC地址的对应关系保存到自己的ARP表中，方便下次时候
 为了而保证ARP表有足够的空间，每一条数据都会有一个生存时间
 超过生存时间，该数据就会被自动删除

### 2. 网络协议

#### 1、TCP：传输控制协议

面向连接：如果采用TCP来传输数据，在传输之前需要先建立TCP连接，建立连接以后才能进行数据的传输
传输可靠：机制，保证了数据的可靠传输，重传机制

数据传输慢

建立连接（TCP三次握手）：

 - 客户端向服务器端发送建立连接的请求（SYN报文）
 - 服务器向客服器端发送连接连接和确认请求（SYN+ACK报文）
 - 客户端向服务器端发送确认消息（ACK报文）

关闭连接（TCP四次分手/四次挥手）：

 - 客户端向服务器发送断开连接的请求（FIN+ACK报文）
 - 服务器端向客户端发送确认请求（ACK报文）
 - 服务器端向客户端发送断开连接的请求（FIN+ACK报文）
 - 客户端向服务器端发送确认请求（ACK报文）

#### 2、UDP：用户数据报协议

非面向连接：发送端和接收端不需要建立连接；发送端把接受到的数据一起传输到网络上，接受端直接从网络上获取

传输不可靠
传输速度快

用在直播等

#### 3、ARP



#### 4、 ICMP

```bash
ping www.baidu.com
```

禁用ping 功能

```bash
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
```

解除禁用

```bash
echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_all
```



## 二、IP

### 1. IP解析

#### 1、IP组成

192.168.1.1

192.168：网络地址

1.1：主机地址



#### 2、ip地址的划分

0.0.0.0/0 所有地址

127.0.0.1/8 本地回环地址



A类：0.0.0.0 - 127.255.255.255/8   255.0.0.0
B类：128.0.0.0 - 191.255.255.255/16  255.255.0.0
C类：192.0.0.0 - 223.255.255.255/24  255.255.255.0

#### 3、mac地址

```bash
ifconfig

ip a

arp -a
```

```bash
arping -I ens33 10.18.44.208
```

 ![image-20220901152824405](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220901152824405.png)

 ![image-20220901152737671](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220901152737671.png)

#### 4、网络管理

1.查看ip地址

```bash
ifconfig ens33	# 只查看ens33网卡
ifconfig	# 查看所有网卡

ip a	# 查看所有网卡
ip a s ens33	# 单独查看ens33
```

临时设置ip地址

```bash
ip a a 192.168.1.250/24 dev ens33

ifconfig  ens33  192.168.1.250/24	#覆盖原来的ip，远程连接会卡死

ifconfig  ens33:0  192.168.2.251/24	#增加新的ip，子网掩码可以不写
```

重启网络恢复原来

```bash
systemctl restart network
```

永久设置ip地址

```bash
vim  /etc/sysconfig/network-scripts/ifcfg-ens33
```

```vim
TYPE="Ethernet"	# 类型
BOOTPROTO="static" 	# 启用静态IP地址,dhcp 动态 static 手动(none)
NAME="ens33"	# 网卡名称
UUID="8071cc7b-d407-4dea-a41e-16f7d2e75ee9"	# 标识
ONBOOT="yes" 		# 是否启用

IPADDR="192.168.1.128" 	# 设置IP地址
PREFIX="24" 				# 设置子网掩码
	# NETMASK=255.255.255.0	 #同子网掩码，写一个
GATEWAY="192.168.21.2" 	# 设置网关 .1  .2(vmware) .254
DNS1="8.8.8.8" 			# 设置主DNS
DNS2="114.114.114.114" 			# 设置备DNS
```

修改完成重启网络

添加网卡要想使用必须添加对应的配置文件

```bash
cp ifcfg-ens33 ifcfg-ens36
cp ifcfg-ens33 ifcfg-ens37
## 分别修改配置文件ip等信息
```

#### 5、bond

1.查看系统是否支持bond，值为m代表隔离

```bash
cat /boot/config-3.10.0-693.el7.x86_64 | grep -i bonding
```

 ![image-20220902101710993](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220902101710993.png)

2.备份网卡信息

```bash
cp /etc/sysconfig/network-scripts/ifcfg-ens33 /etc/sysconfig/network-scripts/ifcfg-ens33.bak
cp /etc/sysconfig/network-scripts/ifcfg-ens36 /etc/sysconfig/network-scripts/ifcfg-ens36.bak
cp /etc/sysconfig/network-scripts/ifcfg-ens37 /etc/sysconfig/network-scripts/ifcfg-ens37.bak
```

3.网卡模板(所有网卡文件都要修改)

```bash
vim ifcfg-ens33

BOOTPROTO=none
DEVICE=ens33 #网卡名称注意别填错
ONBOOT=yes
USERCTL=no    #普通用户是否可控制此设备
MASTER=bond0  # 绑定聚合文件ifcfg-bond0
SLAVE=yes
```

4.聚合模版文件

```bash
vi /etc/sysconfig/network-scripts/ifcfg-bond0

DEVICE=bond0
ONBOOT=yes
USERCTL=no
BONDING_OPTS="mode=1 miimon=100 fail_over_mac=1"
BOOTPROTO=none
IPADDR=10.0.0.128
NETMASK=255.255.255.0
GATEWAY=10.0.0.2
ZONE=public
DNS1=114.114.114.114
```

系统每100ms 监测一次链路连接状态
默认fail_over_mac=0，当发生错误时，只改slave的mac不改bond；fail_over_mac=1时，只改bond不改slave

5.重启网络服务

```bash
systemctl restart network
```

6.查看绑定结果

```bash
ip a
```



7.查看bond信息

```bash
cat /proc/net/bonding/bond0
```



注意：
如果没有加载模块，需要加载模块

```bash
lsmod |grep bonding
modprobe bonding
lsmod |grep bonding
```

bonding               152656  0 

Mode 0 (balance-rr) 轮转（Round-robin）策略：从头到尾顺序的在每一个slave接口上面发送数据包
Mode 1 (active-backup) 备份（主备）策略：只有一个slave被激活，仅当活动的slave接口失败时才会激活其他slave

验证：

ifdown  ens33  down掉bond0绑定的网卡  自动切换到另外一个网卡  
开启新的服务器进行访问测试，切换后依然可以访问那说bond成功了

`ifup` 激活

#### 6、路由

桥接模式：

​	桥接出来的虚拟机和宿主机属于同一个网络

​	在不同的宿主机上的虚拟机可以互相通信

仅主机：

​	只能跟宿主机通信，不能访问外网，同一个宿主机下的虚拟机可以互相通信

NET模式：(网络地址转换)

​	重新创建一个网络，该网络跟宿主机网络利用vmware虚拟路由器进行数据的转发

​	nat模式的虚拟机可以访问外网

​	nat模式的虚拟机只能跟宿主机本身创建的虚拟机进行通信，不可以跨宿主机通信













