# Linux

## 一、步入Linux世界

### 1. Linux内核：操作系统

1.硬件设备 管理使用 
2.软件程序 （系统）------>操作软件 
3.系统内存 
4.文件管理：保存文件，删除文件，修改文件 

- 文件系统：读、写的标准（ext4、FAT32、exFAT、NTFS、APFS...） 
- Linux查看文件系统：

```bash
df -T
```

 <!-- more -->

### 2. GNU

GUN是一个组织

> Unix上具有的一些软件，Linux内核本身没有，所以GNU他们模仿Unix，为Linux写了一些必要的软件

1.GNU核心：
	原本在Unix上的一些命令和工具，被模仿(移植)到了Linux上。供Linux使用的这套I具:coreutils coreutilities软件包。
（1）用来处理文件的工具
（2）用来操作文本的工具
（3）用来管理进程的工具 

2.Shell
	提供给用户使用的软件:用户拿它来使用电脑，并且和电脑交互
	命令行壳层提供一个命令行界面(CLI) ;而图形壳层提供一个图形用户界面(GUI)
	Linux shell ------> CLI  COmmand-Line Interface 

3.CLI shell
	Bash shell 基础shell 

4.GUI 

- X Windows：windows
- KDE  ： windows、macOS
- GNOME ： manjaro
- Unity ：Ubuntu

### 3. 开机启动流程

linux centos 7 开机启动流程
加电自检
MBR引导，引导系统系统
加载内核信息
启动第一个服务（systemd）
加载启动级别
加载初始化脚本
启动开机自启的服务
进入到登录界面

### 4. 启动级别

>   lrwxrwxrwx  1 root root  15 Oct 15  2019 /usr/lib/systemd/system/runlevel0.target	# 关机
>   lrwxrwxrwx  1 root root  13 Oct 15  2019 /usr/lib/systemd/system/runlevel1.target	# 单用户系统，不需要登陆
>   lrwxrwxrwx  1 root root  17 Oct 15  2019 /usr/lib/systemd/system/runlevel2.target	# 多用户系统，命令行模式登陆
>   lrwxrwxrwx  1 root root  17 Oct 15  2019 /usr/lib/systemd/system/runlevel3.target	# 最小化界面
>   lrwxrwxrwx  1 root root  17 Oct 15  2019 /usr/lib/systemd/system/runlevel4.target	# 未使用模式
>   lrwxrwxrwx  1 root root  16 Oct 15  2019 /usr/lib/systemd/system/runlevel5.target	# 图形化界面
>   lrwxrwxrwx  1 root root  13 Oct 15  2019 /usr/lib/systemd/system/runlevel6.target	# reboot

7个级别： 0 - 6

0 关闭
3 最小化
5 图形化
6 重启

```bash
init 0 	# 关机
init 3
init 5
init 6 # 重启 === reboot
```

**注意：**
如果我在图形化界面中执行init 3，图形化界面会立刻切换成最小化
如果我在最小化界面中执行init 5,（前提是图形化已安装）最小化会立刻切换成图形化



## 二、Bash shell最基本命令

### 1. CLI命令行

查看某个命令帮助

```bash
man xx
```

点击进入：[查命令网址](https://wangchujiang.com/linux-command/)



### 2. 目录结构

windows 分盘 CDEF...

C:\software\Devsoft\Git

**Linux一切皆为文件**

> ~：用户home目录
> /：Linux最根目录
> **/bin** ：二进制目录 GNU工具 ls等自带的命令 （存放许多用户级） 
> **/etc** ：系统配置文件 
> **/home** ：主目录，存放所有普通用户家目录 
> /lib ：库目录
> lost+found ：意外文件
> /mnt ：挂载目录，U盘(挂载 ---> 外在设备和电脑进行连接)
> **/proc** ：伪文件系统（存放虚拟文件，例：进程文件）
> /run ：运行目录
> /snap
> /tmp ：临时目录文件
> **/var**： 可变目录 log日志文件，存放变化文件 
> **/boot** ：启动目录，内核文件 
> **/dev** ：设备目录（windows设备管理器） 
> /media：媒体目录
> **/opt** ：可选目录，空目录 
> **/root** ：root用户主目录，管理员 
> **/sbin** ：系统二进制目录，GNU高级管理员使用的命令工具 
> /srv ：服务目录 本地服务
> **/usr** ：用户二进制目录，GNU工具（系统文件，C://Windows）

![image-20220810203203126](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220810203203126.png)



FHS 文件系统层级标准

> www.pathname.com

### 3. cd命令

```bash
cd		# 进入用户主目录；
cd /	# 进入根目录
cd ~	# 进入用户主目录；
cd ..	# 返回上级目录（若当前目录为“/“，则执行完后还在“/"；".."为上级目录的意思）；
cd ../..	# 返回上两级目录；

cd !$	# 把上个命令的参数作为cd参数使用。

pwd		# 显示当前目录
```

组合命令：

```bash
cd .. && ls -alF
```

 ![image-20220810203302682](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220810203302682.png)



### 4. 文件目录

#### 1、路径

##### 1. 绝对路径（全）

Windows：盘符:\文件及\文件夹...\文件夹\文件名.后缀名

```bash
gedit /home/frank/Documents/doc/1.txt	# 打开文件（macos --> open）
```

文件不存在时，临时创建一个文件

##### 2. 相对路径

```bash
gedit ./Documents/doc/1.txt
gedit ~/Documents/doc/1.txt
```

单点符 . 当前文件夹

双点符 .. 当前目录的父目录

### 5. ls命令：

```bash
ls       # 仅列出当前目录可见文件
ls -l    # 列出当前目录可见文件详细信息
ls -hl   # 列出详细信息并以可读大小显示文件大小，增加文件大小单位
ls -al   # 列出所有文件（包括隐藏）的详细信息
```



```bash
ls -F		# -F区分文件夹和文件
ls Documents/ -F -R		# -R列出内容
ls -FR
## 文件扩展匹配符
ls -l xxx*	# 找到xxx开头的文件 
ls -l xxx?	# *代表多个符号，？代表一个符号
## 元字符通配符
ls -l f[a-x]ank.txt
ls -l f[!a-x]ank.txt	# 取反
```

 ![7_F9`ACQC`7_I~MLVGHWB56](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/7_F9%60ACQC%607_I%7EMLVGHWB56.png)

文件扩展匹配符  *  ?

元字符通配符  [ ]

ll显示内容：

 ![image-20220817095041143](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220817095041143.png)

扩展：

```bash
ls /opt/ /home/		# 同时查看多个目录文件
ls /bin | grep ls	# 过滤ls
```

 ![ERW3QVTZE](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/ERW3QVTZE.png)

查看文件inode号

```bash
ls -i file
```



### 6. touch

**touch命令** 有两个功能：一是用于把已存在文件的时间标签更新为系统当前的时间（默认方式），它们的数据将原封不动地保留下来；二是用来创建新的空文件。

```bash
touch 2.txt		# 创建新的空文件

touch /opt/test.c /opt/test_1.c
touch /opt/{test.c,test_1.c}

touch /opt/file{1..100}.txt
touch /opt/test_{a..z}.c
```

### 7. cp

将源文件或目录复制到目标文件或目录中

```bash
cp (你想复制的文件) (你想复制到哪)
cp 1.txt 2.txt	# 2.txt文件不存在，创建

cp -i 1.txt 2.txt
-i：覆盖既有文件之前先询问用户；

cp -r /home/frank/Documents/doc /home/frank/Downloads/

-R/r：递归处理，将指定目录下的所有文件与子目录一并处理；
-v：详细显示命令执行的操作。
```



### 8. ln文件链接

符号链接（软链接）**Symbolic link**（soft links）

```bash
ln -s 1.java 1_linkfile	# 创建软链接（多）

ln 1.java 2_linkfile	# 创建硬链接
```

cp命令复制后果：复制的是链接文件

 ![G9P6W](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/G9P6W.jpg)

 ![aaofaofa](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/aaofaofa.jpg)

软连接：

1.源文件删除后，链接文件不可用
2.软链接文件，源文件和链接文件inode号不同
3.软链接可以链接目录
4.软链接可以跨分区

硬链接：

1.源文件删除后，链接文件可用
2.硬链接源文件和链接文件inode相同
3.硬链接不可以链接目录
4.硬链接不可以跨分区



### 9. mv重命名/移动

**移动文件，文件夹**

```bash
mv 123.c xxx.c	# 重命名
mv text.c ~/Document/	# 移动文件
```

 ![IQKK2N](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/IQKK2N.png)



```bash
cd !$
## 上一条命令的最后一个目录，中间不能有其他命令
```



**注意事项：**

mv与cp的结果不同，mv好像文件“搬家”，文件个数并未增加。而cp对文件进行复制，文件个数增加了。

### 10. rm删除

```bash
rm xxx.xx
```

 ![iafhoafhoaf](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/iafhoafhoaf.png)

```bash
rm -rf /*	# r遍历，f强制
```

**非常危险**

使用替代

```bash
rm -ri dd/
```

### 11. mkdir创建文件夹

创建文件夹 make directories

创建子目录

```bash
mkdir -p js/src/util	# 递归创建子目录
-v	显示创建过程

mkdir -pv {a/{c,d/{e,f/{h,i}}},b/g}		
## 在当前目录下创建一个a和b的目录．在ａ目录下在创建ｃ和ｄ，在ｄ下创建一个ｅ和ｆ，在ｂ下创建一个ｇ，在ｆ下创建一个ｈ和ｉ
```

用来删除空目录

```bash
rmdir		# 空目录
```



### 12. 文件类型

查看文件类型

```bash
file 1.txt
1.txt: ASCII text
cd ..
file Project
Project: directory
```

>   \-  普通文件（文本文件，二进制文件，压缩文件，电影，图片。。。）
>   d 目录文件（蓝色）
>   b 块设备文件（块设备）存储设备硬盘，U盘 /dev/sda, /dev/sda1
>   c 字符设备文件（字符设备）打印机，终端 /dev/tty1, /dev/zero
>   l 链接文件（淡蓝色）
>   s 套接字文件(ll /dev/log)
>   p 管道文件

### 13. 文件系统

xfs ext2 ext3 nfs ntfs

### 14. cat，more，less，tail，head查看文件内容

#### 1、cat只适合看短的文件

```bash
cat -A 1.txt

tac xx	# 倒看
```

 ![oaioaia](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/oaioaia.png)

#### 2、more按页展示

```bash
more 1.txt
```



- 按 `Space`键：显示文本的下一屏内容。
- 按 `Enter` 键：只显示文本的下一行内容。
- 按斜线符`|`：接着输入一个模式，可以在文本中寻找下一个相匹配的模式。
- 按 `H` 键：显示帮助屏，该屏上有相关的帮助信息。
- 按 `B` 键：显示上一屏内容。
- 按 `Q` 键：退出more命令。

#### 3、less分屏上下翻页浏览文件内容

用less命令显示文件时，用 `PageUp` 键向上翻页，用  `PageDown` 键向下翻页。要退出less程序，应按 `Q` 键

#### 4、tail和head

tail显示文件结尾

```bash
tail demo.c		# 只显示后面10行
tail -n 2 demo.c	# 只显示后面两行
```

head显示文件开头

```bash
head -3 demo.c	# 看前3行
```

实时看文件内容

```bash
tailf
tail -f	# 当文件被删除后，就算重新创建不能实时查看
tail -F	# 能够实时查看文件内容，文件删除重新创建依然能够实时查看
```

### 15. date显示当前日期时间

```bash
date +%y%m%d%H%M%S		# 输出时间
date +%y-%m-%d\ %H:%M:%S	# 输出时间
date +%F	# 输出日期
date +%D	# 输出日期
date -s 8:57	# 设置时间
```

 ![image-20220817110043398](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220817110043398.png)



## 三、更上一层系统上的shell

### 1. 进程（“任务管理器”）

system monitor，系统进程

#### 1、静态查看 ps

用于报告当前系统的进程状态（PID：医院挂号）

```bash
ps
ps axo pid,comm,pcpu	# 查看进程的PID、名称以及CPU 占用率
ps -aux | grep named	# 查看named进程详细信息

ps aux | less	#分页显示

a 只能查看所有终端进程
u 显示进程拥有者
x 显示系统内所有进程

-f 显示完整的格式列表
-e 显示所有进程
-l 长格式显示
```

 ![WCCKAZWJ](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/WCCKAZWJ.png)

>   **USER**: 运行进程的用户
>   **PID**： 进程ID
>   **%CPU**: CPU占用率
>   **%MEM**: 内存占用率
>
>   VSZ： 占用虚拟内存
>   RSS: 占用实际内存，驻留内存
>   TTY： 进程运行的终端，在终端运行显示终端标识，不在终端运行显示"?"
>   STAT： 进程状态 man ps (/STATE)



进程状态：

>   **R** 运行
>   **S** 可中断睡眠 Sleep
>   **T** 停止的进程
>   **Z** 僵尸进程

进程属性：

>   Ss s 进程的领导者，父进程
>   S< < 优先级较高的进程
>   SN N 优先级较低的进程
>   R+ + 表示运行在前台的进程组
>
>   Sl l 以线程的方式运行

```bash
ps aux --sort %cpu	# 按照CPU占用从小到大
ps aux --sort -%cpu # 从大到小

## 查看系统中占用CPU最多的进程
ps aux --sort %cpu | tail -1
ps aux --sort -%cpu | head -2

## 查看系统中占用CPU前十
ps aux --sort %cpu | tail
ps aux --sort -%cpu | head -11

## 同样的可以查看占用内存
%mem
```

查看Apache进程

```bash
ps auxf | grep httpd
```

 ![kajdkad](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/kajdkad.png)

2.自定义显示 axo

axo顺序不能改

```bash
ps axo user,pid,ppid,%mem,command
```

指定进程查看相关进程信息

```bash
ps axo user,pid,ppid,%mem,command | grep httpd
```

 ![oadnana](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/oadnana.png)

E.G.

自定义字段显示根据%cpu排序显示前10行

```bash
ps axo user,pid,ppid,%mem,%cpu,command --sort -%cpu | head
```

![image-20220822155845737](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220822155845737.png)



3.pid目录

数字目录对应进程pid

![image-20220822160729125](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220822160729125.png)

```bash
ls /run/
```

![image-20220822161025725](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220822161025725.png)

以.pid结尾的文件，pid文件

```bash
pidof sshd
pgrep sshd
lsof -i:22
```

![image-20220822161448120](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220822161448120.png)



4.扩展

```bash
w
who
```

用来查看谁连接过

 ![image-20220822162013710](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220822162013710.png)



#### 2、动态查看 top / htop

实时动态地查看系统的整体运行情况

```bash
top
htop
```

1.top



#### 3、网络进程

```bash
yum -y install net-tools
```

系统上每一个服务都有自己默认的端口号

>   vnc 5900
>   ssh 22
>   http 80 (nginx apache)
>   https 443
>   mariadb/mysql 3306
>   php 9000
>   redis 6379
>   tomcat (8080 8009 8005)

```bash
netstat -auntpl | grep 22		# 过滤22号端口

-a 所有的进程
-u udp进程
-n 显示段口号  vnc 5900 ftp21、20  ssh 22 http 80 (apache,nginx) https 443   mysql/mariadb  3306  php 9000   redis 6379   tomcat(8009 8080 8005)
-t tcp进程
-p 显示程序的pid 和 名称
-l listening 监听的进程
```

ss 推荐使用

```bash
ss -antpl | grep 22

查看网络进程
-a 所有的进程
-u udp进程
-n 显示段口号 5900 vnc 21、20 ftp
-t tcp进程
-p 显示程序的pid 和 名称
-l listening 监听的
```



### 2. kill

打开记事本，结束记事本进程

 ![kankland](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/kankland.png)

```bash
## 语法格式
kill +信号 pid

kill -9 xx	# 强制终止

-1   HUP  重新加载进程或者重新加载配置文件
-9   KILL 强制杀死
-15  TERM 正常杀死(这个信号可以默认不写)
-18  CONT 激活进程
-19  STOP 挂起进程
```

注意：

1信号pid不会改变，但重启服务pid会改变



pkill：

```bash
yum -y install psmisc

pkill -9 进程名称
pkill -9 -t 终端 名称

## 不加-9只杀死在终端上运行的进程，加-9连终端本身一起干掉
```

### 3. mount挂载

同汇编

```bash
sudo fdisk -l	# 显示U盘真实默认路径
sudo mount /dev/sdc1 /mnt/ 	# 把原本挂载路径映射到另一个目录，挂载两个目录

sudo umount /mnt	# 卸载，一定要退出默认挂载目录，才能卸载成功
```

安卓手机挂载

```bash
/run/user/1000/gvfs	# MTP协议
```

### 4. df 显示磁盘的信息

```bash
df	# 显示磁盘的相关信息
df -h	# 查看挂载的目录
```

不能把分区挂载到目录，可以目录挂载到目录

```bash
du # 显示每个文件和目录的磁盘使用空间
```

### 5. sort

对文本文件中所有行进行排序。

```bash
sort demo.c	# 按每一行第一个字符排，文件没影响，只是展示
sort -n demo.c	# 按照数字大小排
```

其他

```bash
-n, --numeric-sort             根据数字排序。
-r, --reverse                  将结果倒序排列。

## 日志非常有用
-M, --month-sort               按照非月份、一月、十二月的顺序排序。

-k, --key=KEYDEF                       通过一个key排序；KEYDEF给出位置和类型。
```

### 6. | 管道符

两个命令合并成一个命令

```bash
du -sh * | sort -nr
```

### 7. grep搜索(基础)

强大的文本搜索工具

```bash
grep 'main' 1.java		# 有main的所有行
grep '^root' /etc/passwd	# 以root开头
grep 'root$' /etc/passwd	# 以root结尾
```

`grep -v`取反

```bash
w | grep -v load | grep -v FROM |awk '{print $3}'
```

打印出第2行第3列

```bash
awk -F : NR==2'{print $3}' /etc/passwd
```



### 8. find文件查找

#### 1、按照文件名

```bash
find /etc -name "ifcfg-eth0"

-name 区分大小写查找
-iname 不区分大小写查找

# 查找
find /etc -iname "ifcfg*"
find /etc -iname "*fg*"
```

#### 2、按照文件大小

```bash
find /etc -size +5M		# 大于5M的
find /etc -size 5M		# 等于5M
find /etc -size -5M		# 小于5M

find /etc -size +5M -ls		# 查看查到的文件的详细信息
```

#### 3、按照时间

```bash
find /etc -mtime +5	# 修改时间超过5天
find /etc -mtime 5	# 修改时间等于5天
find /etc -mtime -5	# 修改时间小于5天
```

查看文件属性(文件大小，时间)

```bash
stat 文件名
```

查找三个时间区别:

>   Access == atime 访问时间
>
>   Modify == mtime 修改时间
>
>   Change == ctime 改变时间



#### 4、按文件属主、属组

```bash
find /home -user jack		# 属主是jack的文件
find /home -group hr	# 属组是hr组的文件

#多条件查找（and or）
find /home -user jack -group hr			# 两者都满足
find /home -user jack -a -group hr	# 并且
find /home -user jack -o -group hr	# 或者

find /home -not -user jack	# 取反，查找不是jack的文件
find /home ! -user jack
```

#### 5、按文件类型

```bash
find /dev -type f 	# f普通
find /dev -type d 	# d目录
l
b
c
s
p
```

#### 6、按文件权限

```bash
# 查找权限为644的文件
find ./ -perm 644

## 查找权限600及以上，不止一个
find  -perm -600
```

 ![image-20220826162941903](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220826162941903.png)

111:644

222:600

333:777

 ![image-20220826163043458](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220826163043458.png)

 ![image-20220826163113293](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220826163113293.png)



#### 7、按正则表达式

```bash
find /etc -regex '.*ifcfg-eth[0-9]'

.* 任意多个字符
[0-9] 任意一个数字
[a-z] 任意一个字母
+ 前面字符一次或者多次
\ 转义符
```

用正则，前边必须加 `.*` (与-name区分)

```bash
find /etc/ -regex '.*ifcfg-ens[0-9][0-9]'
```

 ![image-20220826163824187](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220826163824187.png)

#### 8、取反

-not / !

```bash
find /etc ! -size 5M		# 不等于5M
find /etc -not -size 5M

find ./ ! -type f	#取反
```

#### 9、查找文件动作

```bash
-ls：类似ls -l的形式显示每一个文件的详细

-print: 显示（不加默认动作）
-delete: 将查询到的文件删除

-ok COMMAND {} ; 每一次操作都需要用户确认,{}表示引用找到的文件,是占位符
-exec COMMAND {} ; 每次操作无需确认
```



例：

```bash
find ./ -name "*.txt" -ok cp  {} /opt \;	#输入y确认
find ./ -name "*.txt" -exec cp  {} /opt \;	#不需要输入y确认
```

 ![32B2U9ZG](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/32B2U9ZG.png)

删除文件

```bash
find ./ -name "*.sh" -delete
find ./ -name "*.sh" -ok rm -rf {} \;
```

etc下conf结尾并且权限为644文件 打包压缩为conf.tar.gz

```bash
## rf
find ./ \( -name "*.conf" -a -perm 644 \) |xargs -i tar rf /opt/conf.tar.gz
```

#### 10、xargs

```bash
find -name "xingdian*.txt" |xargs rm -rf
find /etc -name "ifcfg-eth0" |xargs -I {} cp -rf {} /var/tmp
find -type f -name "*.txt" |xargs -i cp {} /tmp/

加 -I 参数 需要事先指定替换字符
加 -i 参数直接用 {}就能代替管道之前的标准输出的内容

推荐使用 -i
```

#### 11、注意

准备工作

```bash
touch yang{1..100}
touch file{1..100}
```

-o

```bash
find -name "*9" -o -name "*8"	#查找文件

```

 ![image-20220829110208167](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220829110208167.png)

```bash
find -name "*9" -o -name "*8" -exec cp {} /opt/ \;
```

 ![image-20220829112118347](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220829112118347.png)

发现只有`*8*` 的文件被复制了

```bash
find \( -name "*9" -o -name "*8" \) -exec cp {} /opt/ \;
```

 ![image-20220829112301611](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220829112301611.png)



-a

```bash
find -name "*9" -a -name "file*"
```

 ![image-20220829112755976](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220829112755976.png)

```bash
find -name "*9" -a -name "file*" | xargs -i cp {} /opt/
```

 ![image-20220829112840931](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220829112840931.png)

```bash
find -name "*9" -a -name "file*" -exec cp {} /opt/ \;
```

 ![image-20220829113004525](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220829113004525.png)

发现 `-a` 不会出现执行一半的情况



### 9. tar解压缩文件

压缩包格式

压缩包格式
.tar.gz
.zip
.tar.bz2
.tar.xz
.tgz
……

cvzf 压缩
xvzf 解压缩
v：显示过程
z：压缩格式
c：建立新的文档
f：指定存档或设备
x：解压

z gzip .tar.gz
j bzip2 .tar.bz2
J xz .tar.xz

unzip

```bash
yum -y install unzip	#安装unzip
unzip demo.zip		#使用unzip
```

压缩只能压缩一个文件

先打包在压缩

```bash
tar -zcvf my_c.tar.gz ./C	# 打包后，以 gzip 压缩
```

将tar包解压

```bash
tar -xvf /opt/soft/test/log.tar.gz

tar xf 7z2201-linux-x64.tar.xz -C /usr/local/7z2201
```

结合find使用一定要用rf

```bash
find ./ -name "file*" |args -i tar rf /opt/file.tar.gz {}
```

特殊文件解压缩：

```bash
gunzip access.log-20220106.gz
```



7z安装使用：

```bash
## 安装
yum install p7zip

## 压缩
7za a  名.7z 被压缩的文件或目录

## 解压
7za x 压缩包.7z -o 解压目录
7za x 压缩包.7z
```



## 四、父子shell

### 1. 父子shell概念

```bash
bash
bash
```

 ![TJ7GVBB7](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/TJ7GVBB7.png)



### 2. 分号在命令中的作用

依次执行

```bash
ls ; pwd ; cd /
#进程列表
echo $BASH_SUBSHELL	# 有没有创建子shell
0

(ls ; pwd ; cd /)
echo $BASH_SUBSHELL
1
```

前面没有生成子shell，后面创建子shell然后执行

### 3. sleep和jobs

```bash
sleep 10	# 终端睡眠10s
sleep 3&	# 放在后台执行执行

ps -f
jobs	# 显示工作状态
jobs -l
```

### 4. coproc协程

挂后台命令

### 5. 外部命令，非外部命令（内建命令）

```bash
type ps	# 外部命令
ps is hashed (/usr/bin/ps)
type cd	#
cd is a shell builtin
```

### 6. alias别名

查看缩写，自己创建一个别名

只能当前用，退出终端不能用

```bash
alias li='ls -li'
```

## 五、环境变量

### 1. windows环境变量

C:\Windows

快速打开软件

```powershell
calc	# 计算器

notepad	# 记事本
# C:\Windows\System32

mspaint	# 画图
```

### 2. 全局变量和局部变量

#### 1、全局变量

```bash
printenv		# 展示所有的环境变量
printenv USER	# 输出当前用户名
printenv HOME	# 输出家目录
echo $HOME		# 输出当前用户的home目录
```

#### 2、局部变量

```bash
set	# 查看局部变量

unset	# 删除设置的变量
```

#### 3、定义用户局部变量

```bash
frank="123"
```

![C5PG9YC4E1FXQY](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/C5PG9YC4E1FXQY.png) 

子shell没有作用

**自己定义变量一定要小写**

#### 4、定义用户全局变量

```bash
export frank="abcdef"
```

 ![K49MAQHU0V5J](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/K49MAQHU0V5J.png)

终端退出后，失效（参考clash代理设置）

在子shell中删除设置的变量，在父shell中依旧可以使用

### 3. 环境变量

查看环境变量

```bash
echo $PATH
```

定义环境变量

```bash
PATH=$PATH:/home/yang/project/
```

退出终端后会失效

看系统环境变量

```bash
cat /etc/profile
```

不同发行版可能bash配置不同

>   ~/.bashrc
>
>   ~/.bash_profile
>
>   ~/.profile
>
>   ~/.bash_login



## 六、软件包管理

### 1. PMS和软件安装

package management system 包管理系统

软件安装、更新、卸载

工具依赖

dpkg软件包管理系统

dpkg是Debian Package的简写，由Debian发行版开发，用于安装、卸载和供给和deb软件包相关的信息。

使用dpkg的发行版

使用dpkg的发行版主要是Debian以及它的派生版如Ubuntu、Linux Mint等。

>   apt-get
>
>   apt-cache
>
>   aptitude	#没人维护，不要使用

RPM软件包管理系统

>    RPM，全称为Redhat Package Manager，是由Red Hat推出的软件包管理系统，现在在各种发行版中普遍使用。

```bash
## Ubuntu命令
apt install sl	# 小火车
apt install cmatrix	# 装逼命令,代码雨

apt update	# 检查更新
apt upgrade	# 更新

apt remove xxx	# 卸载
```



uname

```bash
uname	# 什么系统
uname -m	# 系统平台架构
uname -a	# 当前系统详细信息
```

 ![image-20220829154943577](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220829154943577.png)

获取系统版本

```bash
cat /etc/redhat-release
```

 ![image-20220829155015797](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220829155015797.png)



### 2. yum仓库

换源：[阿里镜像站](https://developer.aliyun.com/mirror/)

CentOS 7.9 2009

```bash
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo
```

源文件保存地址：`/etc/yum.repos.d/ `下以 **.repo** 结尾的文件

基础仓库：Base

扩展仓库：epel

```bash
yum clean all	# 清除缓存
rm -rf /var/cache/yum/	# 删除yum缓存
yum makecache	# 新建缓存

yum repolist	# 查询可用仓库列表

	install		# 安装
	reinstall	# 重新安装
	remove		# 卸载
	provides	# 查询命令对应的软件包

	update	# 更新
	upgrade

	info	# 显示包信息
	
yum search xx软件包名	#搜索软件包
```

### 3. 组包

列出组包

```bash
yum grouplist
yum group list
```

 ![image-20220830091329534](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220830091329534.png)

安装卸载查看组包

```bash
yum -y groupinstall "Virtualization Host"	# 安装组包

groupremove	# 卸载
groupinfo	# 查看组包信息
```



### 3. 自制yum源：

```bash
标签
仓库名
地址
签名
仓库启用
签名key
```

 ![OWZH2](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/OWZH2.png)

例：

更改yum配置，可以保存缓存

```bash
vim /etc/yum.conf

# 把keepcache改为1
```

 ![MEGSBX2POU97MC12SA](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/MEGSBX2POU97MC12SA.png)

```bash
## /etc/yum.repos.d/创建my.repo

[my]
name=my repo
baseurl=file:///mnt/myyum
rnabled=1
```

创建目录`/mnt/myyum`

可以把.rpm软件包放到`/mnt/myyum`下



使用命令把该目录建成软件包目录

```bash
createrepo /mnt/myyum/

yum clean all	# 清除缓存

yum makecache	# 重建缓存
```

验证仓库是否可用

```bash
yum repolist
```

 ![DT37GXIC](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/DT37GXIC.png)

### 4. rpm

```bash
rpm -ivh 软件包名称/软件包链接地址
    -i install
    -vh verbose human	

rpm -ivh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm

## 查询软件安装路径
rpm -ql 软件名称

## 查询已安装的软件包
rpm -qa
rpm -qa | grep nginx	# 判断软件包是否安装

## 查询软件详细信息
rpm -qi 软件名称

## 查询某一个文件是由哪个软件产生的
rpm -qf /etc/passwd
rpm -qf /bin/rpm

## 软件卸载
rpm -e 软件名称

## 软件卸载
rpm -qc  软件名称

## 了解
--force  在安装的时候用(强制安装)
--nodeps 在卸载的时候用(卸载的时候不检查依赖关系)
```



### 2. 扩展yum-utils

下载yum-utils

```bash
yum -y install yum-utils

yum-config-manager xxx
```

#### 1、数据库安装

方法一：

```bash
yum-config-manager --enable mysql57-community	# 开启mysql57仓库
yum-config-manager --disable mysql80-community	# 关闭mysql80仓库
```

方法二：

修改 `/etc/yum.repos.d` 下的 `.repo` 文件

#### 2、docker安装

```bash
yum-config-manager --add-repo repo文件网址

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

或者

```bash
cd /etc/yum.repos.d/
wget https://download.docker.com/linux/centos/docker-ce.repo
或者：
cp docker-ce.repo /etc/yum.repos.d/
```





## 七、用户和权限

### 1. 用户user

#### 1、创建用户 useradd

```bash
useradd t1		# 创建一个名为t1的用户
useradd -d /user1 user1		# 创建一个用户名为user1并指定用户的家目录为/user1
useradd -u 2000 user2		# 创建一个用户名为user2并指定用户的uid为2000
useradd -g 2000 user4		# 创建一个用户名为user4并指定用户的gid为2000
useradd -c "this is ceshi" user6	# 创建一个用户名为user6并为该用户设定描述内容为this is ceshi
useradd -s /sbin/nologin user7		# 创建一个用户名为user7并设定该用户不允许登录
useradd -M user8			# 创建一个用户名为user8并不创建家目录

-d 指定家目录（自定义家目录）
-u 指定uid
-g 指定gid
-c 指定描述
-s 指定登录shell
-M 不创建家目录

useradd -s /sbin/nologin -M user9	#不能登陆，没有家目录
```

#### 2、查看用户id id

```bash
id user9
```

 ![image-20220818171017132](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220818171017132.png)



#### 3、修改用户 usermod

```bash
usermod -l frank user2	# 修改用户user2改名为frank
usermod -u 3000 user3	# 修改用户user3的uid为3000
usermod -g 2002 user4	# 修改用户user4的gid为2002
usermod -c "this is hello" user6	# 修改用户user6的描述为“this is hello”
usermod -d /user7 user7	# 修改用户user7的家目录为/user7
usermod -s /sbin/nologin user8		# 将user8设定为不允许登录
```

修改用户家目录问题

```bash
useradd yang	#创建用户
mkdir /yang
usermod -d /yang yang
```

 ![image-20220819095031719](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220819095031719.png)

没有用户变量,所以要把用户变量拷贝过来

```bash
cp -r /home/yang/.bash* /yang/
```

 ![image-20220819095201996](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220819095201996.png)



#### 4、改用户密码 passwd

```bash
passwd	# 默认改root账户密码
passwd user1	# 修改用户user1密码

## 非交互式设置密码
# 给diandiange这个用户设定密码为123
echo "123"  | passwd --stdin user1
echo "123456"  | passwd --stdin root
```

先创建用户密码对应文件，格式为username:password，如abc:abc123，必须以这种格式来书写，并且不能有空行，保存成文本文件user.txt，然后执行chpasswd命令：

```bash
chpasswd < user.txt
```

#### 5、删除用户 userdel

```bash
userdel zhangsan	# 删除不彻底（家目录，邮件文件会保留）

userdel -r zhangsan   # 彻底删除
```

#### 6、用户切换 su

```bash
su - user1
```

#### 7、附加组

```bash
## 新组覆盖原有组
useradd -G group user

## 如果用户存在组，追加一个附加组
useradd -aG group user
```



#### 8、注意

uid如果我们不指定，默认根据上一个用户uid的值+1

默认情况下，创建的普通用户是可以登录的（/bin/bash）

不允许登录（/sbin/nologin）

在系统中有很多可以登录的shell，除了/bin/bash以外，

```bash
cat /etc/shells

/bin/sh
/bin/bash
/sbin/nologin	#（不可以登录）
/usr/bin/sh
/usr/bin/bash
/usr/sbin/nologin	#（不可以登录）
```

Ubuntu20.04 系统用户 UID < 500

```bash
yang:x:1002:1002::/home/yang:/bin/bash

用户名:密码:UID:GID（组ID）:描述:用户家目录:用户默认登录的shell
```

更改/etc/passwd，存放用户密码

```bash
cat /etc/shadow	#
```



`/etc/ hosts.allow  hosts.deny `

设置禁止和允许用户登录

### 2. 组groups

小组目的：共享资源的权限

不同发行版略有差异

查看组：

```bash
cat /etc/group	# 查看组

root:x:0:
组名:密码占位符:gid:组里的用户
```

基本增删改使用：

```bash
## 创建组：
groupadd hr		# 创建hr组
groupadd -g 4000 cw		# 创建一个gid为4000的组

## 删除组
groupdel hr

## 修改组：
groupmod -g 6000 cw	# 修改组的gid
groupmod -n abc cw	# 修改组名为abc，新 --> 旧
```

组内添加删除用户

```bash
## 在组中添加用户：
usermod  -aG hr user1	# 给用户user1添加附加组
gpasswd -a user1 hr		# 给hr这个组添加user1的用户，先写用户

# 同时添加多个用户
gpasswd -M user1,user2 hr

## 将user1从hr组中删除
gpasswd -d user1 hr	
```

用户提权：

将用户添加到轮子组，添加到轮子组的用户就具备了管理员的权限，可以执行管理员的命令

```bash
## 1.用户存在，将用户加入到轮子组
gpasswd -a user01 wheel
usermod -aG wheel user01

## 2.用户不存在，创建的时候加入轮子组
useradd user -G wheel

## 3.改文件
visudo

## Allow root to run any commands anywhere
root    ALL=(ALL)       ALL
user1 ALL=(ALL)     ALL			## 添加这行
```



### 3. 服务器忘记密码

1.服务器关机重启

2.按e进救援模式

3.找到UTF-8，后面输入：rd.break console=tty0

在救援模式下

4.Ctrl + X

5.需要将/sysroot重新挂载为可读可写：mount -o rw,remount /sysroot

6.切换到临时根目录下：chroot /sysroot

修改密码：passwd

7.关闭selinux目的是修改的密码生效

vi /etc/selinux/config，编辑上面的文件 然后将selinux=的内容改为disabled

8.因为对文件的修改，为了确保开机时重新设定 SELinux ，必须在根目录下添加隐藏文件 .autorelabel
	touch /.autorelabel
	exit
	reboot



### 4. 文件权限

 ![GJP_VN2RO](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/GJP_VN2RO.png)

rwxr-xr-x

rwx 组创始人权限（文件所有者权限）

r-x 组下属成员权限（文件所属组权限）

r-x 其他组成员权限（其他用户权限）

>   r   代表可以对文件进行读操作，查看目录内容
>   w 代表可以对文件进行写操作,目录创建删除
>   x  代表可以执行该文件，可以进入目录



 ![XZKPZG8B](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/XZKPZG8B.png)

菜鸟教程地址：

https://www.runoob.com/linux/linux-comm-chmod.html



修改文件所有者和组

```bash
chown user1 demo.c	# 只修改所有者

chown user1. demo.c	# 修改所有者和所属组都为user1

chown .group1 demo.c	# 修改文件所属组

chown user1.group1 demo.c	# 修改所有者为user1，所属组为group1


## 修改目录
chown user1.group1 project -R	# 对project目录及目录下所有文件修改

## 区别
chown user1.group1 project/*	# 仅对project目录下所有文件修改，不修改目录本身

## project下有目录也有文件
chown user1.group1 project/* -R
```

设置文件的权限

r: 读	4

w: 写	2

x: 执行	1

| #    | 权限       | rwx  | 二进制 |
| :--- | :--------- | :--- | :----- |
| 7    | 读+写+执行 | rwx  | 111    |
| 6    | 读+写      | rw-  | 110    |
| 5    | 读+执行    | r-x  | 101    |
| 4    | 只读       | r--  | 100    |
| 3    | 写+执行    | -wx  | 011    |
| 2    | 只写       | -w-  | 010    |
| 1    | 只执行     | --x  | 001    |
| 0    | 无         | ---  | 000    |

修改权限(+，=，-)：

参数：u/g/o     rwx

```bash
## + 在原有的基础上增加
chmod o+wx 1.c
```

 ![H25GEMB8C](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/H25GEMB8C.png)

```bash
## 直接赋值权限
chmod g=wx 1.c
```

 ![8WRA](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/8WRA.png)



```bash
## 给2.c所有人减少读权限
chmod a-r 2.c

## 给2.c所有人加可执行权限
chmod a+x 2.c
```

 ![XBZO27W](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/XBZO27W.png)

将文件 file1.txt 与 file2.txt 设为该文件拥有者，与其所属同一个群体者可写入，但其他以外的人则不可写入 :

```bash
chmod ug+w,o-w file1.txt file2.txt
```

使用数字方式

```bash
chomd 777 file 	# 所有人所有权限

## 同chown
chmod 777 project/*		# 不包含目录
chmod 777 project/* -R	# 包含目录
```

文件的默认权限：644

目录的默认权限：755



### 5. 高级权限

添加高级权限命令：

```bash
chmod u+s file	# 给文件增加suid权限
chmod g+s dir/	# 使文件拥有组继承权限
chmod o+t dir/	# 文件所有者才能删除文件（root可以）
```

删除高级权限：

```bash
chmod u-s file
chmod g+s dir/
chmod o+t dir/
```



#### 1、suid

普通用户可以通过suid权限进行提权(二进制文件/命令文件)

suid 普通用户通过suid提权 <针对文件>

suid只能给命令添加，当给命令添加了suid之后，后面再有人去执行这个命令的时候就会拥有命令操作符所有者的权限

E.G.

普通用户没有权限查看/etc/shadow文件

所以把cat命令提权，普通用户也会享有提权后的cat命令权限

```bash
## a:字母的方式
chmod u+s /bin/cat

## b:数字的方式
chmod 4777 /bin/cat
```

之后普通用户可以使用提权后的cat查看/etc/shadow文件

 ![image-20220822093230402](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220822093230402.png)

**注意：**

suid只能给命令添加，当给命令添加了suid之后，后面再有人去执行这个命令的时候就会拥有命令操作符所有者的权限



#### 2、sgid

组继承权限

sgid 新建文件继承目录属组 <针对目录>

```bash
chmod g+s /home/hr
chmod 2777 /home/hr
```

修改目录组继承权限之后，创建的文件才会继承目录属组



#### 3、sticky

防止他人误删除(不限制root用户)

sticky：用户只能删除自己的文件 <针对目录>

```bash
chmod o+t /home/dir1
chmod 1777 /home/dir1
```

谁可以删除：
root
文件的所有者
目录的所有者



### 6. 隐藏权限

**用来限制root用户**

```bash
## 添加隐藏权限
chattr +a 文件	# 允许往文件里追加内容

chattr +i 文件	# 只能看，其他的都不能

## 查看隐藏权限
lsattr file


## 删除隐藏权限
chattr -a file
chattr -i file
```

### 7. umask权限掩码

默认的umask 022

创建一个文件默认权限是644  

创建一个目录默认权限是755

文件：666

目录：777



例：

umask 234

文件：666

根据umask为234，计算创建文件的权限是多少

666 rw- rw- rw- 110 110 110             110 110 110

234 -w- -wx r-- 010 011 100 （取反）	 101 100 011

​										100 100 010  r-- r-- -w-   442



## 八、vim

### 1. vim使用

>   三种工作模式：
>   命令模式
>   插入模式/编辑模式
>   尾行模式/扩展命令模式
>   注意：
>   在任意一个模式下，只要对文件进行编辑和修改，不允许使用鼠标进行移动
>   命令模式：
>   使用上下左右键移动光标
>   想在那个位置进行修改，就把光标移动到那个位置
>
>   把光标移动到行首：快捷键HOME 0
>   把光标移动到行尾：快捷键END $
>   把光标从任意一个位置移动到最后一行：G
>   把光标从任意一个位置移动到第一行：gg
>   把光标直接移动到第3行：3gg
>
>   文件编辑快捷键（只局限于在一个文件内部使用）
>   复制光标所在行：yy
>   复制光标所在行及以下三行：4yy
>   粘贴：p
>   删除某一行：dd 删除光标所在行
>   删除多行：2dd
>   文件中所有内容删除：dG  删除光标所在行到最后一行
>   因为光标在第一行，所有dG可以删除文件所有内容
>   撤销：误删除了 u
>   删除单个字符：x
>   删除光标所在位置到行尾的所有内容：D
>   字符的替换：r 选中要替换的字符，然后使用r,输入替换后的字符
>
>   在我们编辑一个文件的时候，使用那个快捷键能加快工作效率，我们就使用那个
>
>   在命令模式下进入插入模式快捷键：（6个）
>   i（最常用的）
>   I：进入插入模式并且光标移动到所在行的行首
>   A：进入插入模式并且光标移动到行在行的行尾
>   a：进入插入模式并且光标移动到下一个字符
>   O：进入插入模式并且光标移动到了上一行
>   o：进入插入模式并且光标移动到了下一行
>
>   尾行模式：
>   从命令模式进入到尾行模式
>   现在在插入模式，进入尾行模式，先进入命令模式
>   :(冒号 英文状态下的冒号 )命令-->尾行
>   w保存
>   q退出
>   wq 保存并退出（最常用的快捷键）
>   ！强制
>   当正常无法保存退出时：
>   wq!  强制保存并退出
>   只能执行强制退出
>   q!



emacs	神之编辑器

vim	编辑器之神

```bash
sudo apt install vim -y		# Ubuntu
yum -y install vim			# CentOS
```



普通模式（命令操作模式）：操作文件

插入模式：编辑（只有插入的时候才是插入模式）



键：`H` 左	`J` 下	`K` 上	`L` 右

翻页：`Ctrl` + `F`：向下一页	`Ctrl` + `B`：向上一页

滚动翻页：`Ctrl` + ``E`：向下		`Ctrl` + `Y`：向上



dw：移除当前所在光标往后的单词

d：跳跃单词首字母

e：跳跃单词最后

w：跳跃到下一个单词首字母



`shift `+ `6`	^	跳跃到本行开头

`shift` + `4`	$	跳跃到本行末尾



在普通模式不能使用 `backspace` 和 `delete` 键

{	}	跳跃{ }大括号

dd：删除（剪切，`p` 可以粘贴）

yw：复制一个单词

y$：从当前开始，复制到行末

p：粘贴



可视化模式：

选择文本 v 进行选择

V 行

全选：V G	d删除，y 复制，

0：补全角落

vaw：快速选择单词

vab：带括号选择单词	( )	小括号

vaB：	{	}	大括号

va<：	<	>	尖括号



代码缩进：

v <、>	左、右缩进（注意shift键）

v 选择，shift + ~ ：字母大小写切换

v + u：全部转化为小写

v + U：大写 



查找：按 / 输入要查找内容，/123，按 n 跳下一个

替换：

```vim
:s/const/let/g		# g一行

:%s/const/let/g		# 全局（不加g只替换每一行第一个）

:9,15/const/let/g	# 9-15行

:%s/const/let/gc	# 有提示，按 y 确认

:5,10 s/.*/#&/ 		# 5-10前加入#字符 （.*整行 &引用查找的内容）
```



### 2. vim基本配置

```bash
vim .vimrc

set syntax=on	# 设置高亮
set tabstop=4
set softtabstop=4
set number	# 行号
set enc=utf-8
set showmatch	# 括号
```

点击进入：[阮一峰Vim 配置入门](https://www.ruanyifeng.com/blog/2018/09/vimrc.html)

## 九、管道和重定向



### 1. 重定向

文件描述符 0 与 进程的标准输入（standard input）
文件描述符 1 与 标准输出（standard output）
文件描述符 2 与 标准错误输出（standard error）

```bash
ls /proc/$$/fd

#   $$ 当前终端的pid
```

输出重定向 (覆盖，追加)
正确输出： 1> 1>> 等价于 > >>
错误输出： 2> 2>>



```bash
date 1> date.txt	# 输出重定向（覆盖）日期时间

date >> date.txt	# 输出重定向（追加）
ls /home/ /aaaaaaaaa >list.txt
```

 ![8C76SQ7W83R0A](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/8C76SQ7W83R0A.png)

```bash
## 错误输出重定向
ls /home/ /aaaaaaaaa >list.txt 2>error.txt
```

 ![GBM3](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/GBM3.png)

```bash
## 正确和错误都输入到相同位置
ls /home/ /aaaaaaaaa &>list.txt

ls /home/ /aaaaaaaaa >list.txt 2>&1
```

 ![WFVM8XP](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/WFVM8XP.png)

```bash
ls /home/ /aaaaaaaaa &>/dev/null

# 返回值扔到回收站
```



### 2. 管道

对字段进行排序：

b.txt中有123456789

```bash
## 对字段进行排序
sort -rn b.txt

-n 按数值，默认按字符排序
-r 逆序
```

 ![GMG1UU40](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/GMG1UU40.png)

uniq去重：

```bash
uniq -c b.txt
```

awk打印指定的字段：

过滤xx列

统计当前/etc/passwd中用户使用的shell类型

思路：取出第七列（shell） | 排序（把相同归类）| 去重

```bash
awk -F: '{print $7}' /etc/passwd
awk -F: '{print $7}' /etc/passwd |sort
awk -F: '{print $7}' /etc/passwd |sort |uniq
awk -F: '{print $NF}' /etc/passwd |sort |uniq -c

-F: 指定字段分隔符,默认以空格或者是tab分隔
$7 第七个字段
$NF表示最后一个字段
$(NF-1)表示倒数第二个字段
NR(NR==2 第二行)

## 以/为分隔符，打印第一列
awk -F "/" '{print $1}'
```



```bash
wc -l			# 统计多少行

cat /etc/passwd | wc -l	# 统计系统多少用户，passwd多少行
```

 ![Q6V7QQDNBEFS1AP97](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/Q6V7QQDNBEFS1AP97.png)

```bash
cat access_log | awk '{print $1}' | sort |uniq |wc -l
看日志			 |		过滤第一列	 |	排序 |去重  |	多少列
```

例：

```bash
cat access_log | wc -l	# 统计网站一共被访问多少次
cat access_log | awk '{print $1}' |sort | uniq | wc -l	# 统计有多少人访问
cat access_log | awk '{print $1}' | sort | uniq -c		# 统计每个人访问次数
cat access_log | awk '{print $1}' | sort | uniq -c | sort -rn | head	# 统计访问量前十
```

![8N99GXK1KB](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/8N99GXK1KB.png)

### 3. tee三通定向



```bash
echo "helloword" | tee file

跟> >> 类似，但不能通用

|tee file 覆盖
|tee -a file 追加
```



## 十、服务管理

### 1. systemctl服务

```bash
systemctl start  vsftpd　　	# 启动服务
systemctl status  vsftpd　　	# 查看服务状态
systemctl status  vsftpd -l　	# 查看服务详细状态
systemctl stop vsftpd　		# 停止服务
systemctl restart vsftpd　　	# 重启服务
systemctl reload  vsftpd　　	# 重新加载配置文件
systemctl enable vsftpd　　　	# 做开机启动
systemctl disable vsftpd　　　	# 关闭开机启动

# 可以判断服务是否处于运行状态
systemctl is-active vsftpd
systemctl is-failed vsftpd

systemctl is-enabled firewalld　　# 可以判断服务是否具有开机启动
```

### 2. 时间服务器

1.配置时间服务器

```bash
## １．修改主机名
hostnamectl set-hostname ntp-server

## ２．关闭防火墙和selinux
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
```

配置;

```bash
rpm -qa | grep ntp
ntp-4.2.4p8-3.el6.x86_64

yum -y install ntp

## NTP Server配置示例：
vim /etc/ntp.conf 		# 配置文件全部删掉，只要下面三行

restrict default nomodify 	# 不允许客户端登录，也不允许客户端修改
server 127.127.1.0 		# 使用本地的bios时间，自己跟自己同步
fudge 127.127.1.0 stratum 10 	# 定义级别，范围0-16，越小越精准

systemctl restart ntpd
systemctl enable ntpd
```

ntp客户端：

```bash
yum -y install ntpdate

ntpdate -b 172.16.110.1(ip地址)
```



### 3. Apache编译安装

[Apache下载](https://httpd.apache.org/download.cgi)

下载apache压缩包并解压

```bash
yum -y install wget

wget https://dlcdn.apache.org/httpd/httpd-2.4.54.tar.gz --no-check-certificate

tar xf httpd-NN.tar.gz
```

下载apr和apr-util并解压到/httpd-NN/srclib/，并分别改名为apr和apr-util

```bash
wget https://dlcdn.apache.org//apr/apr-1.7.0.tar.gz --no-check-certificate
wget https://dlcdn.apache.org//apr/apr-util-1.6.1.tar.gz --no-check-certificate

tar xf apr-1.7.0.tar.gz -C /httpd-NN/srclib/apr
tar xf apr/apr-util-1.6.1.tar.gz -C /httpd-NN/srclib/apr-util
```

在httpd-NN目录下执行

```bash
mkdir /usr/local/apache
./configure --prefix=/usr/local/apache

make && make install
```

**注：编译安装必备依赖环境**

```bash
yum -y install apr apr-util ncurses ncurses-devel openssl-devel bison gcc gcc-c++ make expat-devel  pcre-devel expat-devel libtool
```



### 4. 日志

#### 1、常见的日志文件(系统、进程、应用程序)

日志分类：系统日志、进程日志、应用程序日志

日志作用：排错、追溯事件、统计流量、审计安全行为

```bash
ls /var/log/
tail /var/log/messages		# 系统主日志文件
tail -f /var/log/messages	# 动态查看日志文件的尾部
tail -f /var/log/secure		# 认证、安全
tail /var/log/cron			# crond、at进程产生的日志
tail /var/log/yum.log		# yum
```

二进制日志

```bash
w		# 当前登录的用户即: /var/log/wtmp日志
last	# 最近登录的用户 /var/log/btmp
lastlog	# 所有用户的登录情况 /var/log/lastlog
```

 ![image-20220902163635741](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220902163635741.png)

 ![image-20220902163542942](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220902163542942.png)

日志存放位置:  存放本地 `/var/log`
日志服务启动: `systemctl start rsyslog`
日志配置文件: `/etc/rsyslog.conf`(主配置文件) `/etc/rsyslog.d/`(子配置文件)

#### 2、集中式日志管理

规则：日志对象.日志级别  日志文件



日志对象：

固定：auth, authpriv, cron, daemon, kern, lpr, mail, mark, news, security (same as auth), syslog,  user, uucp 

自定义：local0 through local7



日志级别：

debug,  info, notice, warning, warn (same as warning), err, error (same as err), crit, alert, emerg, panic (same as emerg)

\* ：代表所有级别

级别依次增加，==级别越低，记录的信息越详细==

日志文件中，记录的信息内容由日志级别决定，记录谁的日志由日志对象决定

debug：最低的，一般不用
info：安装信息，警告信息，错误信息
notice：相当与提示
warn/warning：警告，错误
error/err：错误，严重错误
alert：告警，表示已经出现问题
emerg：恐慌级别



例：

将内核日志文件定义到`/var/log/kern.log`

```bash
touch /var/log/kern.log

vim /etc/rsyslog.conf

	kern.*  /var/log/kern.log
```



#### 3、自定义日志

修改日志配置文件
​	指定日志存放文件和位置
​	指定对应的日志级别（确定记录信息内容）
​	指定日志对象（这个对象要做到能够记录ssh这个服务）

自定义sshd日志：

修改ssh服务配置文件
​	让ssh这个服务去绑定已有的日志对象（local0 - local7）
​	ssh --> local2

1.修改sshd服务主配置文件：
将`/etc/ssh/sshd_config` 的#SyslogFacility AUTHPRIV改为 SyslogFacility local2

```bash
vim /etc/ssh/sshd_config

SyslogFacility local2  # 设置ssh的日志定义由local2设备来记录
```

2.在rsyslog的主配置文件里加上：`local2.* 	/var/log/ssh`

```bash
vim /etc/rsyslog.conf

local2.* 	/var/log/ssh
```

3.重启服务

```bash
systemctl restart sshd		# 重启sshd服务

systemctl restart rsyslog	# 重启日志服务
```

 ![image-20220905103839080](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220905103839080.png)



4.远程日志服务器

发送端：

```bash
vim /etc/rsyslog.conf

## 加上  接收端IP地址
*.*   @192.168.1.19	# 注意@:使用udp  @@:使用tcp
```

接收端：

```bash
vim /etc/rsyslog.conf
```

修改配置文件打开UDP接收功能

>   $ModLoad imudp
>   $UDPServerRun 514

两台服务器都重新启动日志

验证：

在发送服务器安装一个软件，产生一条日志`yum -y install gcc`

在接受服务器的messages日志文件查看（`tailf /var/log/message`）

 ![image-20220905111208939](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220905111208939.png)



#### 4、日志切割

`/etc/logrotate.conf` 主配置文件

`/etc/logrotate.d/*` 子配置文件

主配置文件：

```bash
vim /etc/logrotate.conf

weekly 		# 轮转的周期，一周轮转
rotate 4 	# 保留4份
create 		# 轮转后创建新文件
dateext 	# 使用日期作为后缀
#compress 	# 是否压缩
```

例：

对于wtmp和btmp这样无主的日志，按照下面配置进行轮转

>   /var/log/wtmp { 	#对该日志文件设置轮转的方法
>      monthly 		#一月轮转一次
>      minsize 1M 		#最小达到1M才轮转，即到了规定的时间未达到大小不会轮转
>      create 0664 root utmp 	#轮转后创建新文件，并设置权限属主和属组
>      rotate 1 		#保留一份
>   }
>
>   /var/log/btmp {
>      missingok 	#丢失不提示
>      monthly 	#每月轮转一次
>      create 0600 root utmp 	#轮转后创建新文件，并设置权限
>      rotate 1 	#保留一份
>   }
>
>   ```bash
>   vim /etc/logrotate.d/yum 	#原有的设置，没有说保存几份，看上面的全局设置
>   ```
>
>   /var/log/yum.log { 	#yum日志文件
>      missingok 		#丢失不提示
>      notifempty 		#如果为空，不轮转
>      size 30k	 	#达到30k就轮转
>      yearly 			#达到一年就轮转一次，两者满足一个就轮转
>      create 0600 root root 	#创建新文件
>   }



### 5. 计划任务

#### 1、at 一次性计划任务

```bash
yum install -y at	# 下载安装

systemctl start atd	# 启动，开机启动
systemctl enable atd
```

查看计划任务

```bash
at -l

cat /var/spool/at/a0000201a62434
```

 ![LFQUQ0TP](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/LFQUQ0TP.png)

删除计划任务

```bash
at -r 任务号
at -d 任务号
atrm 任务号
```

创建任务：

```bash
at 11:00 12/31/2022
> ls /
> <EOF>		# Ctrl + D结束
```

`tea time` 下午茶 4pm



#### 2、crontab循环计划任务

`* * * * *` 分 时 日 月 周(0/7周日)

```bash
## 保存位置，以用户名命名
ls /var/spool/cron/

crontab -e		# 创建命令（vim使用，可以dd删除命令）
crontab -l		# 查看当前用户的计划任务
crontab -r 		# 删除整个用户的计划任务(默认当前用户)
crontab -e -u user1	# -u指定用户
```

`var/spool/mail/` 邮件 循环计划任务没执行一次都会给指定用户发送一次邮件

把yang用户添加cron.deny

 ![BCLK_DWKW8](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/BCLK_DWKW8.png)

 ![NNC22AM5YBI8PZ9X974](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/NNC22AM5YBI8PZ9X974.png)

切换到yang，发现crontab不能用

 ![HAP08ED343G](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/HAP08ED343G.png)

把yang从cron.deny删除，crontab能用

 ![TYD3B0H2RZDFD](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/TYD3B0H2RZDFD.png)



### 6. FTP服务

C/S架构

server端（必须 `vsftpd`）
client端（可选，windows/linux，server端自己访问自己）

ftp服务器默认对外共享的目录：`/var/ftp/`
		配置文件: `/etc/vsftpd/vsftpd.conf`

**注意**

客户端报错

 ![image-20220906172918666](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220906172918666.png)

查看服务端

 ![image-20220906173033498](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220906173033498.png)

解决办法：修改ftp共享目录权限

```bash
chmod 755 /var/ftp/ -R
systemctl restart vsftpd
```



#### 1、基本配置

vsftpd的被动模式是默认开启的，可以关闭，主动模式永远开启，不能关闭
主动模式： 21端口负责连接，20端口负责传输数据

vsftp服务器关闭被动模式：

```bash
vim /etc/vsftpd/vsftpd.conf

pasv_enable=NO
```

lftp客户端关闭被动模式：

```bash
yum -y install lftp
lftp 10.36.139.62

## 临时关闭
set ftp:passive-mode off
exit

## 永久关闭
vim /etc/lftp.conf

set ftp:passive-mode off
```

 ![BBREIKR7DNF6GG67UVXLKT](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/BBREIKR7DNF6GG67UVXLKT.png)

#### 2、FTP部署

##### 1. vsftpd配置匿名用户

1.编辑配置文件

```bash
vim vsftpd.conf
```

>   write_enable=YES
>
>   anonymous_enable=YES
>   anon_upload_enable=YES
>   anon_mkdir_write_enable=YES
>   anon_other_write_enable=YES

2、常用的匿名FTP配置项

>   anonymous_enable=YES 		# 是否允许匿名用户访问
>   anon_umask=022 		# 匿名用户所上传文件的权限掩码
>   anon_root=/var/ftp 	# 设置匿名用户的FTP根目录
>   anon_upload_enable=YES 		# 是否允许匿名用户上传文件
>   anon_mkdir_write_enable=YES 			# 是否允许匿名用户允许创建目录
>   anon_other_write_enable=YES 			# 是否允许匿名用户有其他写入权（改名，删除，覆盖）
>   anon_max_rate=0 	# 限制最大传输速率（字节/秒）0为无限制

3、开启 vsftp 服务

```bash
systemctl start vsftpd

netstat -lnpt | grep vsftpd
```



##### 2. vsftpd配置本地用户

1.创建用户

```bash
useradd zhangsan
useradd lisi

echo "123456" | passwd --stdin zhangsan
echo "123456" | passwd --stdin lisi
```

2.修改配置文件

```bash
vim /etc/vsftpd/vsftpd.conf
```

>   local_enable=YES
>   local_umask=077
>   chroot_local_user=YES
>   allow_writeable_chroot=YES
>   write_enable=YES

默认情况下是我们匿名账户的根目录
对于普通用户的根目录来讲，默认情况下ftp本地账户访问的根目录是自己的家目录
打开了上传和下载功能



3、常用的本地用户FTP配置项

>   local_enable=YES 	# 是否允许本地系统用户访问
>   local_umask=022 	# 本地用户所上传文件的权限掩码
>   local_root=/var/ftp # 设置本地用户的FTP根目录
>   chroot_list_enable=YES 	# 表示是否开启chroot的环境，默认没有开启
>   chroot_list_file=/etc/vsftpd/chroot_list	# 表示写在/etc/vsftpd/chroot_list文件里面的用户是不可以出chroot环境的。默认是可以的。
>   Chroot_local_user=YES 	# 表示所有写在/etc/vsftpd/chroot_list文件里面的用户是可以出chroot环境的，和上面的相反。
>   local_max_rate=0 	# 限制最大传输速率（字节/秒）0为无限制

4、添加用户到白名单

```bash
vim /etc/vsftpd/user_list

zhangsan
lisi
```

5、重启服务

```bash
systemctl restart vsftpd
```

#### 3、FTP远程仓库

防火墙 selinux

##### 1. 仓库端

1.安装ftp服务，并启动

```bash
yum -y install vsftpd
mkdir /opt/registry
```

编辑配置文件(自定义共享目录)

```bash
vim /etc/vsftpd/vsftpd.conf

anon_root=/opt/registrg	#最后一行追加
```

```bash
systemctl restart vsftpd
```

默认仓库位置：`/var/ftp` 不需要修改配置文件

2.创建目录，作为仓库目录（存放.rpm包）

```bash
mkdir /opt/registry/centos
```

3.将rpm包放到centos目录下

4.做成软件包目录

```bash
createrepo /opt/registry/centos/
```

##### 2. 客户端

不需要挂载(NFS 才需要)，不需要lftp(客户端工具 x)

创建仓库文件

```bash
cd /etc/yum.repos.d/
vim registry.repo
```

```repo
[Registry]
name=This is Registry
baseurl=ftp://10.0.0.37/centos
enabled=1
gpgcheck=0
```

验证

```bash
yum repolist
```



### 7. NFS部署

1.关闭防火墙和selinux

2.安装

```bash
yum -y install nfs-utils
systemctl start nfs
systemctl enable nfs-server
```

3.修改配置文件

创建共享目录`mkdir /opt/nfs-share`

```bash
vim /etc/exports

/opt/nfs-share *(ro,sync)	# 以只读方式共享
# 对外共享目录 共享给谁 权限属性

sync：sync传输过程中将数据直接写入内存和硬盘
no_root_squash:
root_squash：当登录NFS主机使用共享目录的使用者是root时，其权限将被转换成为匿名使用者，通常它的UID与GID都会变成nobody身份。

## 2
/share/dir2   172.16.60.0/24(rw,sync,no_root_squash)

指定一台主机去掉子网掩码
```

共享生效

```bash
exportfs -rv 	# 重新刷新共享,类似重启服务

systemctl restart nfs
```



4.客户端

安装nfs-utils `yum -y install nfs-utils`

查看存储端共享

```bash
showmount -e 10.36.139.106
```

 ![2U0Z3TG7DHW](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/2U0Z3TG7DHW.png)

创建挂载目录 `mkdir /mnt/nfs`

永久挂载NFS

```bash
vim /etc/fstab

10.36.139.106:/opt/nfs-share    /mnt/nfs    nfs   defaults,_netdev 0 0

mount -a	# 挂载
```

查看磁盘挂载结果：

 ![D0NK4S3KINOQQX2Z](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/D0NK4S3KINOQQX2Z.png)



### 8. DNS域名系统

#### 1、DNS概念

“.com”是顶级域名； .like .vip .top .cn .我爱你 .edu .中国
“aliyun.com”是主域名（也可称托管一级域名），主要指企业名
“example.aliyun.com”是子域名（也可称为托管二级域名）
“www.example.aliyun.com”是子域名的子域（也可称为托管三级域名）

#### 2、DNS客户端

##### 1.  安装工具

```bash
yum -y isntall bind-utils
```

##### 2. host

```bash
host www.baidu.com
## 跟DNS服务器
host www.baidu.com 114.114.114.114
```

 ![ALNGTSO2EHYHU](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/ALNGTSO2EHYHU.png)

##### 3. nslookup

```bash
nslookup www.baidu.com
nslookup server
```

 ![aiakfkafa](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/aiakfkafa.png)

##### 4. dig

```bash
dig www.baidu.com
```

 ![OYN4AK3YY4Q5T](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/OYN4AK3YY4Q5T.png)

##### 5. 配置DNS

```bash
cd  /etc/sysconfig/network-scripts/
vim ifcfg-ens33

# 临时修改
vim /etc/resolv.conf
```

>   TYPE="Ethernet"	# 类型
>   BOOTPROTO="static" 	# 启用静态IP地址,dhcp 动态 static 手动(none)
>   NAME="ens33"	# 网卡名称
>   UUID="8071cc7b-d407-4dea-a41e-16f7d2e75ee9"	# 标识
>   ONBOOT="yes" 		# 是否启用
>
>   IPADDR="192.168.21.128" 	# 设置IP地址
>   PREFIX="24" 				# 设置子网掩码
>   	 `# NETMASK=255.255.255.0`	 #同子网掩码，写一个
>   GATEWAY="192.168.21.2" 	# 设置网关 .1  .2(vmware) .254
>   DNS1="8.8.8.8" 			# 设置主DNS
>   DNS2="114.114.114.114" 		# 设置备DNS

### 9. 远程管理服务

#### 1、ssh

安装软件

```bash
yum install openssh*  -y
```

ssh默认端口号：22

##### 1. 配置文件

server：`/etc/ssh/sshd_config`

>   `Port 2222`	# 指定ssh服务的端口号
>   `SyslogFacility AUTHPRIV`	# 指定日志对象
>   `LogLevel INFO`	# 日志级别
>   `PermitRootLogin`	# yes/no是否允许root账户远程登录
>   `LoginGraceTime 2m`	# 如果用户未成功登录，服务器将在此时间后断开连接默认120s,值为0不限制
>   `MaxAuthTries6`	# 每个连接允许的最大身份验证尝试次数
>   `MaxSessions 10`	# 支持连接会话的个数
>   `AuthorizedKeysFile ~/.ssh/authorized_keys`	# 指定存 放用户身份验证的公钥的文件



如果有需要用到其他参数，参看配置文件的man手册



client: `/etc/ssh/ssh_config`
```bash
Port 2222	# 相当于 修改了ssh命令默认的连接端口
```

注意：服务器端修改完配置文件，需要重后服务，才能生效，客户端配置文件修改完成直接生效


##### 2. 服务端

启动服务：

```bash
systemctl start sshd
```

查看服务状态

```bash
lsof -i:22

ss -auntpl | grep ssh
```

关闭防火墙和selinux

##### 3. 客户端

远程登录

```bash
ssh  10.36.139.62
ssh  10.36.139.62 -u user1
ssh  root@10.36.139.62 -u user1 -p 123
```

==如果账户没有设置密码，不能登陆==

##### 4. 无密码登录

```bash
ssh-keygen		# 产生公钥和私钥
ssh-copy-id  -i 10.36.139.106	# 拷贝公钥给对方
ssh 10.36.139.106	# 直接登录，不需要输入密码
```

**注意：**

指纹不匹配问题

```bash
rm ~/.ssh/known_hosts	# 删除已建立过连接主机的密钥
```

##### 5. 远程拷贝

```bash
scp 源文件 目标路径
scp -r 源目录 目标路径

scp /a.txt 10.36.139.106:/		# 把a.txt给他
scp 10.36.139.106:/a.txt ./ 	# 把他的拿下来

scp 192.168.2.108:/a.txt 192.168.2.109:/ 	# 把左边的给右边

-P 2222		# 指定端口2222
```



#### 2、JumpServer

2核4G 干净的服务器

1.环境准备工作

关闭防火墙 selinux 网络（最好静态）

...



### 10. 操作系统初始化

安全角度：

1.用户和组，删除

2.提升root用户的密码强度

3.ssh服务 修改端口 禁止root账户登录 限制登录失败的次数

4.`/etc/profile` 多长时间不操作注销账户

5.禁止ping

```bash
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all	# 禁止
echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_all	# 解除禁止
```

6.远程5分钟无操作自动注销

```bash
vim /etc/profile
## 添加
export TMOUT=300   # 5分钟自动注销
```



其他角度：

1.关闭防火墙和selinux （临时关闭和永久关闭）

2.更换yum仓库（Base + epel 国内）清理缓存 加载缓存

3.安装常用的软件：vim wget ntpdate  zsh unzip ...

4.检查网络是否畅通

5.服务器进行时间同步

6.关闭不需要的软件

……..

初始化的操作写成脚本，所有的服务器只需要执行这个脚本



### 11. WEB服务

主流3个Web服务器：Apache、Nginx、IIS(Windows Server)

#### 1、web中间件

Java：tomcat weblogic
Python：uwsgi wsgi
PHP：php php-fpm

#### 2、Apache基本使用

##### 1. 介绍

> `/etc/httpd/conf/` 存放apache的主配置文件
>
> `httpd.conf` 主配置文件名称
>
> `/etc/httpd/conf.d/` 存放apache的子配置文件(apache虚拟主机配置文件)
>
> `*.conf`都是子配置文件
>
> `/etc/httpd/logs`存放日志文件的目录 链接到`/var/log/httpd`
>
> `/etc/httpd/run/httpd.pid` Apache的pid文件 链接到`/run/httpd/httpd.pid`
>
> `/var/www/html` 默认的网站发布目录，网站代码存放的目录
>
> 自定义网站发布目录
>
> `index.html` 默认的主页名称

##### 2. 配置文件

文件位置：`/etc/httpd/conf/httpd.conf`

```bash
vim /etc/httpd/conf/httpd.conf
```

>   serverRoot "/etc/httpd"	# 存放配置文件的目录
>
>   Listen 80		# 指定监听端口
>
>   User apache		# 子进程的用户	安装Apache自动创建
>   Group apache	# 子进程的组
>
>   ServerAdmin root@localhost		# 设置管理员邮件地址
>
>   DocumentRoot "/var/www/html"	# 指定网站发布目录
>
>   <Directory />		# 标签 指定目录属性（网站发布目录）
>       AllowOverride none	# 允许所有的请求访问
>       Require all denied	# 设置是否启用htpasswd文件  基于用户的访问控制文件
>   </Directory>
>
>   ErrorLog "logs/error_log"	# 定义apache的错误日志
>
>   LogLevel warn	# 定义日志级别 （debug, info, notice, warn, error, crit，alert, emerg）
>
>   LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined	# 定义日志格式 （格式+名字）
>
>   CustomLog "logs/access_log" combined	# 定义apache访问日志  （文件+日志格式名字）
>
>   IncludeOptional conf.d/*.conf	# 加载子配置文件

 ![image-20220811104456712](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220811104456712.png)

设置`DocumentRoot`指定目录的属性

```conf
<Directory "/var/www/html">		# 网站容器开始标识
    Options Indexes FollowSymLinks	# 找不到主页时，以目录的方式呈现，并允许链接到网站根目录以外
    AllowOverride all		# none不使用.htaccess控制,all允许
    Require all granted		# granted表示运行所有访问，denied表示拒绝所有访问
</Directory>		# 容器结束
```



 ![image-20220811105103794](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220811105103794.png)

 Apache日志![image-20220811105214184](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220811105214184.png)

> `%h`：远程主机IP地址
> `%l`：远程日志名
> `%u`：访问user
> `%t`：收到请求时间
> `"%r" `：请求第一行，请求方式(GET、POST) 请求位置　协议　协议版本
> `%>s` ：状态码　304　403　404
> `%b` ：响应内容大小
> `%{Referer}i` ：请求的URL路径
> `%{User-Agent}i`：客户端信息　chrome firefox edge

![image-20220811114927373](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220811114927373.png)

日志可以自定义

```conf
LogFormat "%h  %>s" yang

CustomLog "logs/yang_access_log" yang
```

查看结果

　![image-20220909144335763](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220909144335763.png)



##### 3. 创建子配置文件

```config
cd /etc/httpd/conf.d/
touch web.conf
vim web.conf

<VirtualHost *:81>
        ServerName localhost
        DocumentRoot /web-1
</VirtualHost>
<Directory "/web-1">  
    AllowOverride all
    Require all granted
</Directory>
```

 ![image-20220811140605411](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220811140605411.png)

在`httpd.conf`添加87监听端口，重载服务

```config
Listen 87

systemctl reload httpd
```

进入`/mnt/project/`添加`index.html`文件，查看是否成功

```bash
cd /mnt/project/
touch index.html

curl 10.36.139.62:87
```

 ![image-20220811141112424](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220811141112424.png)

##### 4. 基于端口的虚拟主机

**保证IP、域名一致**

创建三个子配置文件

`A.config` `B.config` `C.config`

```config
<VirtualHost *:81>
        ServerName localhost
        DocumentRoot /web-1
</VirtualHost>
<Directory "/web-1"> 
    AllowOverride all
    Require all granted
</Directory>
```

```conf
<VirtualHost *:82>
        ServerName localhost
        DocumentRoot /web-2
</VirtualHost>
<Directory "/web-2"> 
    AllowOverride all
    Require all granted
</Directory>
```

```conf
<VirtualHost *:83>
        ServerName localhost
        DocumentRoot /web-3
</VirtualHost>
<Directory "/web-3"> 
    AllowOverride all
    Require all granted
</Directory>
```

在`/etc/httpd/conf/httpd.conf`添加`81 82 83` 监听端口

在`/`目录下创建`web-1` `web-2` `web-3` 3个目录存放project

重启httpd服务

在浏览器分别访问IP对应端口号：

>   http://192.168.1.22:81/
>
>   http://192.168.1.22:82/
>
>   http://192.168.1.22:83/



##### 5. 基于域名的虚拟主机

**保证端口、IP一致**

修改`A.config` `B.config` `C.config`

```conf
<VirtualHost *:81>
        ServerName www.a.com
        DocumentRoot /web-1
</VirtualHost>
<Directory "/web-1"> 
    AllowOverride all
    Require all granted
</Directory>
```

```conf
<VirtualHost *:81>
        ServerName www.b.com
        DocumentRoot /web-2
</VirtualHost>
<Directory "/web-2"> 
    AllowOverride all
    Require all granted
</Directory>
```

```conf
<VirtualHost *:81>
        ServerName www.c.com
        DocumentRoot /web-3
</VirtualHost>
<Directory "/web-3"> 
    AllowOverride all
    Require all granted
</Directory>
```

重启httpd服务

在windows中`C:\Windows\System32\drivers\etc\hosts.ics`

>   192.168.1.22 www.a.com www.b.com www.c.com

浏览器访问

>   www.a.com:81
>
>   www.b.com:81
>
>   www.c.com:81



##### 6. 基于IP的虚拟主机

**保证域名、端口一致**

添加本地ip地址

```bash
ip a a 192.168.1.221/24 dev ens33
ip a a 192.168.1.222/24 dev ens33
ip a a 192.168.1.223/24 dev ens33
```

修改apache配置文件`A.config` `B.config` `C.config`

```bash
<VirtualHost 192.168.1.221:81>
        ServerName localhost
        DocumentRoot /web-1
</VirtualHost>
<Directory "/web-1"> 
    AllowOverride all
    Require all granted
</Directory>
```

```bash
<VirtualHost 192.168.1.222:81>
        ServerName localhost
        DocumentRoot /web-2
</VirtualHost>
<Directory "/web-2"> 
    AllowOverride all
    Require all granted
</Directory>
```

```bash
<VirtualHost 192.168.1.223:81>
        ServerName localhost
        DocumentRoot /web-3
</VirtualHost>
<Directory "/web-3"> 
    AllowOverride all
    Require all granted
</Directory>
```

重启服务，输入三个ip+端口查看内容

>   http://192.168.1.221:81/
>
>   http://192.168.1.222:81/
>
>   http://192.168.1.223:81/



##### 7. 基于用户的访问控制

创建用户(第一次加`c`创建文件第二次不需要，m　md5加密)

```bash
htpasswd -cm /etc/httpd/password yang
```

输入两次密码

更改文件

>   `AllowOverride AuthConfig` 	# 启用用户的访问控制
>
>   `AuthName "Restricted Files"` 	# 认证名称，自定义
>
>   `AuthType Basic` 	# 认证类型 默认Basic
>
>   `AuthBasicProvider file` # 可选参数 认证内容来自于文件
>
>   `AuthUserFile "/etc/httpd/password"` 	# 存放用户和密码的文件
>
>   `Require user yang`		# 指定可以访问的用户

 ![image-20220811172531335](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220811172531335.png)



所有的配置结束后，重新启动服务，浏览器访问验证：

![image-20220811172709426](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220811172709426.png)

输入yang 123

 ![image-20220811172801509](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220811172801509.png)

##### 8. rewrite规则

编辑game.conf文件，更改windows端hosts文件

 ![image-20220811174653527](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220811174653527.png)

R=301 强制外部重定向

NC 不区分大小写

[OR] 或者

在浏览器地址栏输入

>   http://www.blog3366.com

 ![image-20220811175045269](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220811175045269.png)

 ![image-20220811175100352](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220811175100352.png)

#### 3、LAMP架构

>  LAMP 即 Linux + Apache + Mysql / MariaDB + Perl / PHP / Python 的首字母缩写。
>
> 这是一组常用来搭建动态网站或者服务器的开源软件

##### 1. 安装

```bash
yum -y install httpd mariadb mariadb-server php php-fpm php-mysql php-gd gd
```

##### 2. 启动

```bash
systemctl start php-fpm httpd mariadb
```

##### 3. 配置

设置mysql登录密码

```bash
mysqladmin -u root  password '123'
```

登录数据库

```bash
mysql -u root -p123
```

创建数据库

```mysql
create database wordpress;

exit	#退出
```

apache配置可以采用默认配置网站发布目录在`/var/www/html/`

添加子配置文件

```bash
vim /etc/httpd/conf.d/wordpress.conf
```

```config
<VirtualHost *:80>
	ServerName localhost
	DocumentRoot /web
</VirtualHost>
<Directory "/web">
	AllowOverride ALL
	Require all granted
</Directory>
```

创建网站发布目录

```bash
mkdir /web
```

PHP使用默认配置

##### 4. 产品上线

>  以 wordpress 为例

解压wordpress放到`/web` 网站发布目录下

验证，浏览器访问



####　4、LNMP架构





















