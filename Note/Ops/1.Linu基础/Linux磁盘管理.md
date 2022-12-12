# Linux磁盘管理

管理磁盘三个流程：分区、格式化/文件系统、挂载

房子：隔间-->放家具/柜子-->装门(目录)

## 一、存储介绍

### 1. NAS

网络附加存储：是一个网络上的文件系统

文件系统：本地文件系统(XFS NTFS ...)，网络文件系统(NFS)



### 2. SAN(Storage Area Network) 

存储区域网络：是一个网络上的磁盘



### 3. DAS(Direct-attached Storage) 

直连存储

例：

U盘，移动硬盘 ...

### 4. 分布式存储

CEPH HDFS GlusterFS openstack(swift) ...

基于C/S架构

都可以构建存储集群



## 二、存储概览

### 1. 以工作原理区分

机械硬盘(HDD)

固态硬盘(SSD)

### 2. 以插拔方式区分

热插拔

非热插拔

### 3. 以分区方式区分

MBR: MBR是主引导记录

GPT: GUID磁碟分割表

区别：

1、MBR分区表最多只能识别2TB左右的空间，大于2TB的容量将无法识别从而导致硬盘空间浪费；GPT分区表则能够识别2TB以上的硬盘空间。

2、MBR分区表最多只能支持4个主分区或三个主分区+1个扩展分区(逻辑分区不限制)；GPT分区表在Windows系统下可以支持128个主分区。

3、在MBR中，分区表的大小是固定的；在GPT分区表头中可自定义分区数量的最大值，也就是说GPT分区表的大小不是固定的。



## 三、磁盘分区

一块硬盘，使用MBR划分分区

A：4主

B：3主 + 1扩展(N个逻辑分区)

### 1. 查看本机硬盘

```bash
ll /dev/sd*
```

 ![image-20220827101505066](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827101505066.png)

列出块状设备

```bash
lsblk
```

 ![image-20220827101607402](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827101607402.png)

### 2. 创建分区

#### 1、fdisk

```bash
fdisk /dev/sdb
```

进入会话模式

m默认为帮助手册

 ![image-20220824155107966](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220824155107966.png)

```bash
n	#新建一个分区

p	#主分区
e	#扩展分区

w	#保存退出
```

主分区最多分4个

primary 主分区

extended 扩展分区

默认选择p

1：主分区号（最大4）

 ![image-20220827103000209](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827103000209.png)

扇区计算：（计算机从0开始数）

![image-20220827102928275](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827102928275.png)

Last sector：结束扇区（2048到N扇区结束）

 ![image-20220827103621394](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827103621394.png)

w：保存操作

#### 2、刷新分区表

刷硬盘，不刷分区（不加序号）

```bash
partprobe /dev/sdb
```

查看分区信息

```bash
fdisk -l /dev/sdb
lsblk
```

 ![image-20220827104414933](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827104414933.png)

 ![image-20220827104518626](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827104518626.png)

磁盘是分区格式化后添加了文件系统，需要挂载才能被系统使用

#### 3、gdisk



## 四、创建文件系统(格式化)

文件系统：ext4  ext3(centos6) xfs(centos7) ext家族　xfs

make file system

```bash
mkfs.ext4  /dev/sdb1

mkfs -t ext4 /dev/sdb1
```

 ![image-20220827105220667](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827105220667.png)



格式化：可以针对磁盘本身，也可以单独给分区进行格式化

新增加的磁盘要想使用，需要挂载到系统中；需要先格式化==分配文件系统



### 扩展

再次创建

![image-20220827112541120](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827112541120.png)

```bash
partprobe /dev/sdb
```

实际不会这样操作，实际一次性划分完成保存

 ![image-20220827112732442](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827112732442.png)

```bash
mkfs -t ext4 /dev/sdb2
mkfs.ext4 /dev/sdb2		#格式化

mkdir /mnt/disk2
mount -t ext4 /dev/sdb2 /mnt/disk2	#挂载
```

 ![image-20220827113310537](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827113310537.png)

创建第三第四分区

 ![image-20220827113729398](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827113729398.png)

创建逻辑分区

先删除4分区

 ![image-20220827115128088](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827115128088.png)

扩展分区一定占用4号分区

创建扩展分区

 ![image-20220827115406369](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827115406369.png)

继续创建

 ![image-20220827115839899](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827115839899.png)

 ![image-20220827120125321](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827120125321.png)

逻辑分区和主分区格式化和挂载方式一样







## 五、磁盘挂载

磁盘是一个文件，挂载到文件夹

### 1. 临时挂载

```bash
mount [参数] 挂载设备 挂载点
```

挂载点需要自己手动创建目录

```bash
## 参数
-t 文件系统类型
	ext3 ext4  xfs ntfs-3g　nfs　cifs （需要-t指定)
	
-o 文件系统属性
	rw 读写
	ro 只读
	remount 重新挂载  根分区也可重新挂载--->mount -o rw,remount /sysroot
		
-a 检测是否挂载成功  mount -a
```



挂载`/dev/sdb1`

```bash
mount -t ext4 /dev/sdb1 /mnt/disk1
```

 ![image-20220827110859416](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827110859416.png)





磁盘挂载和分区挂载是一样的

例：

```bash
mount /dev/sdb1 /opt	#把/dev/sdb1挂载到/opt	
mount -t ext4 /dev/sdb1 /mnt/disk1	#指定文件系统为ext4挂载

mount -t nfs  192.168.0.253:/abc /opt
```

卸载

```bash
umount 挂载点/设备名
```

例：

```bash
umount /dev/sdb1
umount /opt
```

刷新分区表  <磁盘或分区>

```bash
partprobe /dev/sdc
```

### 2. 永久挂载

修改fstab文件

```bash
vim /etc/fstab
```

 ![image-20220825100705434](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220825100705434.png)

第1列:挂载设备（3种写法）

(1)/dev/sda5

(2)10.11.59.110:/abc

(3)UUID=设备的uuid  rhel6 rhel7的默认写法(`blkid /dev/sda1`获取uuid)

第2列:挂载点

第3列:文件系统类型

第4列:文件系统属性

第5列:是否对文件系统进行(磁带)备份

0 不备份

1 1天一次

2 2天一次

第6列:是否检查文件系统

0 不检查

1 先检查

2 后检查



**扩展：**

/etc/rc.d/rc.local 开机启动

```bash
vim /etc/rc.d/rc.local

touch /root/11.c	# 例

chmod a+x /etc/rc.d/rc.local
```

`reboot`重启验证

## 六、交换分区Swap

交换分区就是一个普通的分区，只是功能不一样

作用：“提升”内存的容量，防止OOM（Out Of Memory，爆内存）

windows：虚拟内存



释放缓存中的内存

```bash
echo 3 >/proc/sys/vm/drop_caches
```



swap分区大小设置规则:

内存小于4GB时，推荐不少于2GB的swap空间；

内存4GB~16GB，推荐不少于4GB的swap空间；

内存16GB~64GB，推荐不少于8GB的swap空间；

内存64GB~256GB，推荐不少于16GB的swap空间



查看当前的交换分区:

```bash
free -m
swapon -s
```

 ![image-20220827141741064](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827141741064.png)

### 1. 准备分区

```bash
lsblk	#看系统当前有没有可用的空间
```

先用`fsdisk`制作一个分区

```bash
fdisk /dev/sdc
```

 ![image-20220827142158828](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827142158828.png)

Id:83常规的数据存储格式

查看Id

```bash
t
L
```

 ![image-20220827142457219](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827142457219.png)

 ![image-20220827142920745](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827142920745.png)

改为82交换分区（不改默认83通过实验也可以成功）

```bash
partprobe /dev/sdc
```

 ![image-20220827143146428](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827143146428.png)



### 2. 格式化

```bash
mkswap /dev/sdc1

swapon /dev/sdc1	#激活swap分区

swapoff /dev/sdc2	#关闭swap分区
```

前后对比：

 ![image-20220827143444222](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827143444222.png)

 ![image-20220827143501838](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827143501838.png)

**扩展：**

不改Id，使用默认83，实验也成功

 ![image-20220827144110334](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827144110334.png)



## 七、LVM逻辑卷

特点：随意扩张大小

 ![image-20220827155847903](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827155847903.png)

**概念：**

1、物理卷--PV（Physical Volume）
  物理卷在逻辑卷管理中处于最底层，它可以是实际物理硬盘上的分区，也可以是整个物理硬盘。

2、卷组--VG（Volumne Group） 
  卷组建立在物理卷之上，一个卷组中至少要包括一个物理卷，在卷组建立之后可动态添加物理卷到卷组中。一个逻辑卷管理系统工程中可以只有一个卷组，也可以拥有多个卷组。

3、逻辑卷--LV（Logical Volume） 
  逻辑卷建立在卷组之上，卷组中的未分配空间可以用于建立新的逻辑卷，逻辑卷建立后可以动态地扩展和缩小空间。系统中的多个逻辑卷要以属于同一个卷组，也可以属于不同的多个卷组。

4、物理区域--PE（Physical Extent） 
  物理区域是物理卷中可用于分配的最小存储单元，物理区域的大小可根据实际情况在建立物理卷时指定。物理区域大小一旦确定将不能更改，同一卷组中的所有物理卷的物理区域大小需要一致。

5、逻辑区域―-LE（Logical Extent） 
  逻辑区域是逻辑卷中可用于分配的最小存储单元，逻辑区域的大小取决于逻辑卷所在卷组中的物理区域的大小。

### 1. 创建LVM

#### 1、PV

准备物理磁盘

 ![image-20220827164223321](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827164223321.png)

将物理磁盘转化为物理卷-PV

```bash
pvcreate /dev/sdf
```

 ![image-20220827164619110](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827164619110.png)



#### 2、VG

创建卷组-VG

```bash
vgcreate vg1 /dev/sdf	#vg1自己起名
```

 ![image-20220827164808032](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827164808032.png)



#### 3、LV

方法一：

```bash
lvcreate -L 4G -n lv1 vg1
# 指定大小 M / G

-L	大小
-n	卷名
vg1	组名
```

 ![image-20220827165204197](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827165204197.png)



#### 4、创建文件系统并挂载

格式化

```bash
mkfs.ext4 /dev/vg1/lv1
# /dev/卷组名/逻辑卷名
```

 ![image-20220827165506675](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827165506675.png)

挂载：

```bash
mkdir /mnt/lv1	#创建挂载点
mount /dev/vg1/lv1 /mnt/lv1/
```

 ![image-20220827165756608](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827165756608.png)









### 2. VG管理

扩大VG `vgextend`

讲`/dev/vg1`容量由5G扩容到10G

1.创建PV

```bash
pvcreate /dev/sdg
```

查看PV

```bash
pvs
```

 ![image-20220827171419805](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827171419805.png)

2.扩展VG

```bash
vgextend vg1 /dev/sdg
```

 ![image-20220827171533664](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827171533664.png)

查看VG

```bash
vgs
```

 ![image-20220827171605379](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827171605379.png)



### 3. LV扩容

扩大LV `lvextend`

```bash
lvextend -L +4G /dev/vg1/lv1
```



先观察文件系统当前容量`df -Th`

 ![image-20220827172217788](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827172217788.png)

发现扩大的容量没有增加进来

FS 扩容

```bash
resize2fs /dev/vg1/lv1
```

 ![image-20220827172508733](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220827172508733.png)







## 八、磁盘阵列

RAID （ Redundant Array of Independent Disks ）即独立磁盘冗余阵列，通常简称为磁盘阵列



## 九、文件系统

### 1. 常用文件系统类型

本地文件系统（不能远程用）
fat32 ntfs ext3 ext4 xfs
网络文件系统
nfs  cifs gludterfs hdfs ceph(分布式文件系统)



查看文件系统信息

```bash
dumpe2fs /dev/vg1/lv2
```

### 2. xfs文件系统修复

检查

```bash
xfs_repair -n /dev/sdb1
```

修复

```bash
xfs_repair  /dev/sdb1
```











