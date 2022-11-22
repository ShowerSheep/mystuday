# KVM 虚拟机

## 一、虚拟化技术概述

### 1、虚拟化产品

分类：

1.桌面级虚拟化

2.企业级虚拟化

```bash
1.Kvm（redhat-----企业级）

2.Vmware:
Vmware-workstation(windows和linux)----桌面级
Vmware-fusion(mac)
Vmware-esxi-----(企业级别)本身就是一个操作系统。

3.hyper-v(微软）

4.Ovm（oracle公司--Windows linux） virtulbox

5.Xen（rhel6之前所有版本默认用的虚拟化产品）
```

企业级和桌面级区别

**桌面级比企业级虚拟化多了一层交互**

所以企业级虚拟化要比桌面级虚拟化性能高，但是hyprtvisor会占用系统的资源



## 二、虚拟化技术简介

### 1、KVM安装

查看CPU是否支持虚拟化

```bash
cat /proc/cpuinfo | grep -E 'vmx|svm'
```

有返回结果说明支持

如果虚拟机ping不通就把防火墙打开

1.需求内核（rhe16以上）

```bash
uname -r
3.10.0-1062.el7.x86_64
```

2.卸载旧kvm

```bash
yum remove `rpm -qa | egrep 'qemu|virt|kvm'` -y
rm -rf /var/lib/libvirt  /etc/libvirt/
```

3.升级软件(升级所有包同时也升级软件和系统内核)

```bash
yum upgrade
```

4.安装软件

```bash
yum install *qemu*  *virt*  librbd1-devel -y

#安装 qemu-kvm libvirt virt-manager 这几个软件
qemu-kvm ： 主包
libvirt：api接口
virt-manager：图形化界面
```

5.启动服务

```bash
systemctl start libvirtd
```

6.查看kvm模块加载

```bash
lsmod | grep kvm

#
kvm_intel             188644  0 
kvm                   621480  1 kvm_intel
irqbypass              13503  1 kvm
如果看到有这两行，说明支持kvm模块
```

### 2、KVM gustos图形方式部署安装虚拟机(掌握)

```bash
virt-manager
```

图形化界面操作

安装完成一台虚拟机之后，网络模式默认是NAT的。也只有这一种网络

### 3、GuestOS安装问题解析

问题1：用图形安装guestOS的时候卡住，升级系统

```bash
yum upgrade
```

问题2：升级系统后安装guest os的时候还是卡住不动

解决：需要在安装宿主机的时候安装兼容性程序（有的同学就没有安装也可以使用，这可能是bug）

### 4、完全文本方式安装虚拟机

```bash
yum install -y vsftpd
```

将DVD镜像上传到服务器

开启vsftpd服务

```bash
systemctl start vsftpd
systemctl enable vsftpd

mkdir /var/ftp/centos7
#挂载
mount CentOS-7-x86_64-DVD-1708.iso /var/ftp/centos7/
```

安装

```bash
virt-install --connect qemu:///system -n vm1 -r 2050 --disk path=/var/lib/libvirt/images/vm1.img,size=5  --os-type=linux --os-variant=centos7.0 --vcpus=1  --location=ftp://192.168.10.128/centos7 -x console=ttyS0 --nographics
```

注意

```bash
virt-install
bash: virt-install: 未找到命令...

yum install libguestfs-tools -y
yum install virt-install.noarch -y

参数解释：
-n name
-r  以M为单位指定分配给虚拟机的内存大小
--disk 指定作为客户机存储的媒介 size以G为单位的存储
--os-type   系统类型
--os-variant 系统类型版本
--vcpus 指定核数，不能超过物理cpu
--location  客户虚拟机安装源下载，必须为镜像挂载在ftp目录下
-x console=ttyS0 执行终端0
--nographics 无图形，文本模式
```

注意：命令敲下去，不要误操作退出安装

![1571888912686](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1571888912686-1598794743570.png)

![1571888994236](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1571888994236-1598794743571.png)

![1571899799370](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1571899799370-1598794743571.png)

![1571899841651](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1571899841651-1598794743571.png)

![1571900561999](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1571900561999-1598794743571.png)

![1584115405588](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1584115405588-1598794743571.png)

![1584277302582](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1584277302582-1598794743571.png)

![1584277352951](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1584277352951-1598794743572.png)

![1584277388759](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1584277388759-1598794743572.png)

![1584277434201](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1584277434201-1598794743572.png)

![1584116022881](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1584116022881-1598794743572.png)

![1584116087341](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1584116087341-1598794743572.png)

![1584116391245](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1584116391245-1598794743572.png)

需要等一会了大约20分钟左右

 ![1584116673077](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1584116673077-1598794743572.png)

按空格退出！

下面操作都是可以鼠标点击的

### 5、模板镜像+配置文件(掌握)

1.虚拟机配置文件

```bash
ls /etc/libvirt/qemu
```

2.储存虚拟机介质

```bash
ls /var/lib/libvirt/images/
```

例

1.拷贝模板镜像和配置文件

```bash
cp /etc/libvirt/qemu/vm2.xml /etc/libvirt/qemu/vm3.xml
cp /var/lib/libvirt/images/vm2.img /var/lib/libvirt/images/vm3.img
```

2.修改配置文件

```bash
vim /etc/libvirt/qemu/vm3.xml
```

```xml
domain type='kvm'>
  <name>vm3</name>  #名字不能一样需要修改
  <uuid>2e3fa6db-ff7f-41c3-bc8f-0428e81ebb57</uuid> #uuid不能一样需要修改
  <memory unit='KiB'>1024000</memory>  #内存，可选
  <currentMemory unit='KiB'>1024000</currentMemory>  #当前内存与上面定义一样
  <vcpu placement='static'>2</vcpu>  #cpu可选
  <os>
    <type arch='x86_64' machine='pc-i440fx-rhel7.0.0'>hvm</type>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/>
    <apic/>
  </features>
  <cpu mode='custom' match='exact' check='partial'>
    <model fallback='allow'>SandyBridge-IBRS</model>
    <feature policy='require' name='md-clear'/>
    <feature policy='require' name='spec-ctrl'/>
    <feature policy='require' name='ssbd'/>
  </cpu>
  <clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <pm>
    <suspend-to-mem enabled='no'/>
    <suspend-to-disk enabled='no'/>
  </pm>
  <devices>
    <emulator>/usr/libexec/qemu-kvm</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/vm3.img'/>   #磁盘镜像需要修改
      <target dev='vda' bus='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>
    </disk>
    <controller type='usb' index='0' model='ich9-ehci1'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x7'/>
    </controller>
    <controller type='usb' index='0' model='ich9-uhci1'>
      <master startport='0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0' multifunction='on'/>
    </controller>
    <controller type='usb' index='0' model='ich9-uhci2'>
      <master startport='2'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x1'/>
    </controller>
    <controller type='usb' index='0' model='ich9-uhci3'>
      <master startport='4'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x2'/>
    </controller>
    <controller type='pci' index='0' model='pci-root'/>
    <controller type='virtio-serial' index='0'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x06' function='0x0'/>
    </controller>
    <interface type='network'>
      <mac address='52:54:00:82:d6:3c'/>  #mac地址不能一样需要修改，只能修改后三段。
      <source network='default'/>
      <model type='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
    </interface>
    <serial type='pty'>
      <target type='isa-serial' port='0'>
        <model name='isa-serial'/>
      </target>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <channel type='unix'>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
      <address type='virtio-serial' controller='0' bus='0' port='1'/>
    </channel>
    <channel type='spicevmc'>
      <target type='virtio' name='com.redhat.spice.0'/>
      <address type='virtio-serial' controller='0' bus='0' port='2'/>
    </channel>
    <input type='tablet' bus='usb'>
      <address type='usb' bus='0' port='1'/>
    </input>
    <input type='mouse' bus='ps2'/>
    <input type='keyboard' bus='ps2'/>
    <graphics type='spice' autoport='yes'>
      <listen type='address'/>
      <image compression='off'/>
    </graphics>
    <sound model='ich6'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x0'/>
    </sound>
    <video>
      <model type='qxl' ram='65536' vram='65536' vgamem='16384' heads='1' primary='yes'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0'/>
    </video>
    <redirdev bus='usb' type='spicevmc'>
      <address type='usb' bus='0' port='2'/>
    </redirdev>
    <redirdev bus='usb' type='spicevmc'>
      <address type='usb' bus='0' port='3'/>
    </redirdev>
    <memballoon model='virtio'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x08' function='0x0'/>
    </memballoon>
    <rng model='virtio'>
      <backend model='random'>/dev/urandom</backend>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x09' function='0x0'/>
    </rng>
  </devices>
</domain>
```

> 必须修改name，uuid,mac地址，其余可选

用vim修改完之后需要define一下配置文件

```bash
virsh define /etc/libvirt/qemu/vm3.xml
systemctl restart libvirtd

#宿主机开启路由转发
vim /etc/sysctl.conf
sysctl -p

net.ipv4.ip_forward = 1
```

查看虚拟机列表

```bash
virsh list --all
```

 ![image-20221122171524669](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221122171524669.png)

![image-20221122171532561](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221122171532561.png)



## 三、KVM虚拟机管理

虚拟机的基本管理命令：
查看
启动
关闭
重启
重置

```bash
#列出在运行状态中的虚拟机
[root@kvm-server ~]# virsh list
 Id    名称                         状态
----------------------------------------------------
 2     vm3                            running

#列出所有虚拟机
[root@kvm-server ~]# virsh list --all
 Id    名称                         状态
----------------------------------------------------
 2     vm3                            running
 -     vm2                            关闭

#查看kvm虚拟机配置文件：
#语法：virsh dumpxml vm_name
[root@kvm-server ~]# virsh dumpxml vm3

#启动
[root@kvm-server ~]# virsh start vm2
域 vm2 已开始

#暂停虚拟机：
[root@kvm-server ~]# virsh suspend vm_name
域 vm2 被挂起

#恢复虚拟机：
[root@kvm-server ~]# virsh resume vm_name
域 vm2 被重新恢复

#关闭：

#方法1：
[root@kvm-server ~]# virsh shutdown vm3
域 vm3 被关闭

#重启：
[root@kvm-server ~]# virsh reboot vm3
域 vm3 正在被重新启动

#重置:
[root@kvm-server ~]# virsh reset vm3
vm3   #断电重启。速度快
Domain vm3 was reset

#删除虚拟机:
[root@kvm-server ~]# virsh undefine vm2
Domain vm2 has been undefined

注意:虚拟机在开启的情况下undefine是无法删除的只是将配置文件删除了，不能删除磁盘文件。需要手动rm
======================

虚拟机开机自动启动:
#如果虚拟机开机自启，里面的服务应该设置的有开机自启，不然没有意义
[root@kvm-server ~]# virsh autostart vm_name
域 vm3标记为自动开始

#此目录默认不存在，在有开机启动的虚拟机时自动创建
[root@kvm-server ~]# ls /etc/libvirt/qemu/autostart/
vm3.xml

#关闭开机启动
[root@kvm-server ~]# virsh autostart --disable vm_name
域 vm3取消标记为自动开始
[root@kvm-server ~]# ls /etc/libvirt/qemu/autostart/

#如何查看已启动的虚拟机ip地址
#假如vm3虚拟机已启动
[root@kvm-server ~]# virsh domifaddr vm3
 名称     MAC 地址           Protocol     Address
-------------------------------------------------------------------------------
 vnet0      52:54:00:82:d6:3c    ipv4         192.168.122.85/24
```



## 四、虚拟机添加设备

### 1、图形方式:

首先，关闭要添加硬件的虚拟机
双击虚拟机，在打开的对话框点击上方的View，点击Details，点击Add Hardware可以选择要添加的虚拟硬件

 ![1571910314774](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1571910314774-1584350545507-1598867849259.png)

 ![1571910431718](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1571910431718-1584350545509-1598867849261.png)

 ![1571910465326](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1571910465326-1584350545509-1598867849261.png)

 ![1571910479417](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/1571910479417-1584350545508-1598867849262.png)

### 2、修改配置文件方式:

我们给虚拟机vm3添加磁盘为例：

首先需要创建出要添加的磁盘

```bash
qemu-img create -f qcow2 /var/lib/libvirt/images/vm4-1.qcow2 5G
```

> 注：创建空的磁盘文件：这里我们创建一个5G的磁盘，不过创建出来，通过ll -h查看大小，看不出它是5G，添加上之后才能看到

```bash
cd /etc/libvirt/qemu/
vim vm3.xml
```

![image-20221122172205846](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221122172205846.png)

加好之后，启动虚拟机

```bash
systemctl restart libvirtd
virsh list --all
virsh start vm3
```

 ![image-20221122172255440](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221122172255440.png)

可以看到我们新添加的磁盘vdb
然后可以正常分区，制作文件系统，进行挂载

### 3、虚拟机克隆

#### 1. 图形界面

Applications （左上角）-----> System Tools ------>Virtual Machine Manager
关闭要克隆的虚拟机，右键点击虚拟机选择Clone

![image-20221122172348528](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221122172348528.png)

#### 2. 在终端执行命令克隆

```bash
[root@kvm-server ~]# virt-clone -o vm2 --auto-clone
正在分配 'vm2-clone.qcow2'                              | 5.0 GB  00:00     
成功克隆 'vm2-clone'。
-o       origin-原始
    
[root@kvm-server ~]# virt-clone -o vm2 -n vm5 --auto-clone
正在分配 'vm5.qcow2'                                    | 5.0 GB  00:00     
成功克隆 'vm5'。
-n :指定新客户机的名字
        
[root@kvm-server ~]# virt-clone -o vm2 -n vm6 -f /var/lib/libvirt/images/vm6.img
正在分配 'vm6.img'                                      | 5.0 GB  00:00     
成功克隆 'vm6'。
-f ，--file NEW_DISKFILE：为新客户机使用新的磁盘镜像文件

#这条命令在克隆的同时，可以指定镜像文件的位置和名称。

[root@kvm-server ~]# virsh list --all
 Id    名称                         状态
----------------------------------------------------
 -     vm2                            关闭
 -     vm2-clone                      关闭
 -     vm3                            关闭
 -     vm5                            关闭
 -     vm6                            关闭
```

### 4、kvm高级命令

#### 1. 建立虚拟机磁盘镜像文件：

磁盘镜像文件格式:
    1.qed  ----不用了
    2.raw     原始格式，性能最好 直接占用你一开始给多少空间 系统就占多少空间 不支持快照
    qcow  先去网上了解一下cow(写时拷贝copy on write) ，性能远不能和raw相比，所以很快夭折了，所以出现了qcow2（性能低下 早就被抛弃）
    3.qcow2 性能上还是不如raw，但是raw不支持快照，qcow2支持快照。

#### 2. 什么叫写时拷贝？
raw立刻分配空间，不管你有没有用到那么多空间
qcow2只是承诺给你分配空间，但是只有当你需要用空间的时候，才会给你空间。最多只给你承诺空间的大小，避免空间浪费

```bash
[root@kvm-server images]# pwd
/var/lib/libvirt/images

#1.建立qcow2格式磁盘文件:
[root@kvm-server images]# qemu-img create -f qcow2 test.img 5G
Formatting 'test.img', fmt=qcow2 size=5368709120 encryption=off cluster_size=65536 lazy_refcounts=off 

#2.建立raw格式磁盘文件:
[root@kvm-server images]# qemu-img create -f raw test.raw 5G
Formatting 'test.raw', fmt=raw size=5368709120 

#查看已经创建的虚拟磁盘文件:
[root@kvm-server images]# qemu-img info test.img
[root@kvm-server images]# qemu-img info test.raw
```

> 挂载磁盘---什么时候用到？
> 先前条件：文件系统没有坏掉

将vm2虚拟机先关闭
查看vm2的磁盘镜像分区信息

```bash
[root@kvm-server images]# virt-df -h -d vm2
文件系统                                  大小      已用空间    可用空间     使用百分比%
vm2:/dev/sda1                            1014M        92M       922M         10%
vm2:/dev/centos/root                      3.5G       863M       2.6G         25%
```

```bash
#1.创建一个挂载目录
[root@kvm-server images]# mkdir /test

#2.挂载虚拟机的根分区到test目录
[root@kvm-server images]# guestmount -d vm2 -m /dev/centos/root --rw /test/
[root@kvm-server images]# cd /test/
[root@kvm-server test]# ls
bin   dev  home  lib64  mnt  proc  run   srv  tmp  var
boot  etc  lib   media  opt  root  sbin  sys  usr
[root@kvm-server test]# cat etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
polkitd:x:999:997:User for polkitd:/:/sbin/nologin
postfix:x:89:89::/var/spool/postfix:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin

#取消挂载
[root@kvm-server ~]# guestunmount /test
```

## 五、KVM存储配置

### 1、存储池

概念：
    kvm必须要配置一个目录当作存储磁盘镜像(存储卷)的目录，我们称这个目录为存储池

kvm默认存储池的位置：`/var/lib/libvirt/images/ `

### 2、图形创建

略

### 3、命令方式

1.创建基于文件夹的存储池（目录，可自定义）

```bash
[root@kvm-server ~]# mkdir -p /data/vmfs
```

2.定义存储池与其目录

```bash
[root@kvm-server ~]# virsh pool-define-as vmdisk --type dir --target /data/vmfs
Pool vmdisk defined
```

解释：vmdisk是新建的存储池的名称。可自定义

3.创建已定义的存储池

```bash
#(1)创建已定义的存储池
[root@kvm-server ~]# virsh pool-build vmdisk
Pool vmdisk built

#(2)查看已定义的存储池，存储池不激活无法使用。
[root@kvm-server ~]# virsh pool-list --all
Name                 State      Autostart 
-------------------------------------------
 default              active     yes       
 ISO                 active     yes       
 vmdisk               inactive   no  
```

4.激活并自动启动已定义的存储池

```bash
[root@kvm-server ~]# virsh pool-start vmdisk
Pool vmdisk started
[root@kvm-server ~]# virsh pool-autostart vmdisk
Pool vmdisk marked as autostarted

[root@kvm-server ~]# virsh pool-list --all
 Name                 State      Autostart 
-------------------------------------------
 default              active     yes       
 ISO                 active     yes       
 vmdisk               active     yes   
```

这里vmdisk存储池就已经创建好了，可以直接在这个存储池中创建虚拟磁盘文件了。

5.在存储池中创建虚拟机存储卷

```bash
[root@kvm-server ~]# virsh vol-create-as vmdisk vm99.qcow2 2G --format qcow2
Vol vm99.qcow2 created

[root@kvm-server ~]# ll /data/vmfs/ -h
总用量 196K
-rw------- 1 root root 193K 10月 25 16:04 vm99.qcow2
```

6.存储池相关管理命令

```bash
#(1)在存储池中删除虚拟机存储卷
[root@kvm-server ~]# virsh vol-delete --pool vmdisk vm99.qcow2
Vol vm99.qcow2 deleted

#(2)取消激活存储池
[root@kvm-server ~]# virsh pool-destroy vmdisk
Pool vmdisk destroyed

#(3)删除存储池定义的目录/data/vmfs
[root@kvm-server ~]# virsh pool-delete vmdisk
Pool vmdisk deleted

#(4)取消定义存储池
[root@kvm-server ~]# virsh pool-undefine vmdisk
Pool vmdisk has been undefined
```

到此kvm存储池配置与管理操作完毕。

## 六、kvm快照

1、为虚拟机vm2创建一个快照（磁盘格式必须为qcow2）

```bash
virsh snapshot-create-as vm2 vm2.snap1
```

注意：如果在创建快照的时候报错：
error: unsupported configuration: internal snapshot for disk vda unsupported for storage type raw

raw不支持snapshot

2、查看磁盘文件格式

```bash
[root@kvm-server images]# qemu-img info /var/lib/libvirt/images/vm2.qcow2
image: /var/lib/libvirt/images/vm2.qcow2
file format: qcow2
virtual size: 5.0G (5368709120 bytes)
disk size: 5.0G
cluster_size: 65536
Format specific information:
    compat: 1.1
    lazy refcounts: true

[root@kvm-server ~]# virsh snapshot-list  vm2   #查看某台虚拟机设备的快照
 Name                 Creation Time             State
```

```bash
#创建一块磁盘
[root@kvm-server ~]# qemu-img create -f raw /var/lib/libvirt/images/vm2-1.raw 2G
Formatting '/var/lib/libvirt/images/vm2-1.raw', fmt=raw size=2147483648 

[root@kvm-server ~]# ll -h /var/lib/libvirt/images/vm2-1.raw
-rw-r--r-- 1 root root 2.0G 10月 25 16:25 /var/lib/libvirt/images/vm2-1.raw

#将其添加到vm2虚拟机上面
[root@kvm-server ~]# cd /etc/libvirt/qemu/
[root@kvm-server qemu]# vim vm2.xml 
```

![image-20221122174056514](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221122174056514.png)

```bash
[root@kvm-server images]# virsh define /etc/libvirt/qemu/vm2.xml
[root@kvm-server images]# virsh start vm2
```

错误

```bash
[root@kvm-server qemu]# virsh snapshot-create-as vm2 vm2.snap1
错误：不支持的配置：存储类型 vdb 不支持磁盘 raw 的内部快照



#磁盘格式的转换
#由于raw的磁盘格式，不支持快照功能，我们需要将其转换为qcow2的格式
[root@kvm-server qemu]# qemu-img convert -O qcow2 /var/lib/libvirt/images/vm2-1.raw  /var/lib/libvirt/images/vm2-1.qcow2

[root@kvm-server qemu]# cd /var/lib/libvirt/images/
[root@kvm-server images]# ll -h 
总用量 21G
-rw------- 1 root root 5.1G 10月 24 18:59 centos7.0.qcow2
-rw-r--r-- 1 root root 193K 10月 25 16:44 vm2-1.qcow2
-rw-r--r-- 1 root root 2.0G 10月 25 16:25 vm2-1.raw
-rw------- 1 root root 5.1G 10月 25 16:13 vm2.qcow2


[root@kvm-server images]# qemu-img info /var/lib/libvirt/images/vm2-1.qcow2
image: /var/lib/libvirt/images/vm2-1.qcow2
file format: qcow2
virtual size: 2.0G (2147483648 bytes)
disk size: 196K
cluster_size: 65536
Format specific information:
    compat: 1.1
    lazy refcounts: false


#然后去修改vm2虚拟机的磁盘格式和名称
[root@kvm-server images]# vim /etc/libvirt/qemu/vm2.xml
```

 ![image-20221122174154663](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221122174154663.png)

```bash
[root@kvm-server images]# virsh define /etc/libvirt/qemu/vm2.xml

#创建快照
[root@kvm-server qemu]# virsh snapshot-create-as vm2 vm2.snap2
已生成域快照 vm2.snap2
```

![image-20221122174221073](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221122174221073.png)

开始做快照

图形化，略

```bash
#登录vm2的虚拟机：
[root@vm2 ~]# mkdir /opt/test

[root@kvm-server ~]# virsh snapshot-create-as vm2 vm2-snap3
已生成域快照 vm2-snap3

#再次登录vm2的虚拟：
[root@vm2 ~]# rm -rf /opt/test/

[root@kvm-server ~]# virsh shutdown vm2
[root@kvm-server ~]# virsh snapshot-create-as vm2 vm2-snap4
已生成域快照 vm2-snap4

#查看快照
[root@kvm-server ~]# virsh snapshot-list vm2 
 名称               生成时间              状态
------------------------------------------------------------
 vm2-snap3            2019-10-30 15:27:15 +0800 running
 vm2-snap4            2019-10-30 15:29:37 +0800 shutoff

#然后将vm2关闭，恢复到快照vm2.snap3
[root@kvm-server ~]# virsh snapshot-revert vm2 vm2-snap3
[root@kvm-server ~]# virsh start vm2
Domain vm2 started

#在vm2虚拟机上查看
[root@vm2 ~]# ls /opt/
test
#可以再恢复到vm2.snap4测试一下

#删除虚拟机快照操作：
[root@kvm-server ~]# virsh shutdown vm2
[root@kvm-server ~]# virsh snapshot-list vm2
 名称               生成时间              状态
------------------------------------------------------------
 vm2-snap3            2019-10-30 15:27:15 +0800 running
 vm2-snap4            2019-10-30 15:29:37 +0800 shutoff

[root@kvm-server ~]# virsh snapshot-delete --snapshotname vm2-snap3 vm2
已删除域快照 vm2-snap3

[root@kvm-server ~]# virsh snapshot-list vm2
 名称               生成时间              状态
------------------------------------------------------------
 vm2-snap4            2019-10-30 15:27:15 +0800 running
```



## 七、kvm网络配置











































