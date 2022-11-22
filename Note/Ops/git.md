# Git 版本控制

版本控制系统 gitlab/github/gitee

## 1、git 布署

环境：

> git-server: `192.168.1.129`
>
> git-client: `192.168.1.130`

安装，所有机器

```bash
yum install -y git
git --version 
```

所有的机器都添加，只要邮箱和用户不一样就可以。

```bash
git config --global user.email "soho@163.com"	#设置邮箱
git config --global user.name "soho"			#添加用户
```

### 1. git 使用

创建版本库

1、创建一个空目录：在中心服务器创建

```bash
mkdir /git-test
useradd git	#创建一个git用户用来运行git
passwd git  #给用户设置密码
cd /git-test/
```

2、通过git init命令把这个目录变成Git可以管理的仓库

创建裸库才可以从别处push（传）代码过来，使用--bare参数------裸

```bash
git init --bare  库名字
```

创建一个裸库

```bash
git init --bare test
chown git.git /git-test -R  #修改权限

# 查看库目录
cd test/
ls
```

### 2. 客户端

```bash
ssh-keygen    #生成秘钥
ssh-copy-id -i git@192.168.1.129   #将秘钥传输到git服务器中的git用户

#克隆git仓库
git clone git@192.168.1.129:/git-test/test/
ls
```

1、创建文件模拟代码提交到仓库

```bash
cd test/
vim a.txt	#随便写
```

2、把文件添加到暂存区：使用 `git add`

```bash
git add a.txt
```

> 注: 这里可以使用 `git add *` 或者 `git add -A`

3、提交文件到本地仓库分支

```bash
git commit -m "add a.txt"
```

4、查看git状态

```bash
git status
```

5、修改文件查看状态

```bash
echo "hello" >>a.txt

git status
```

6、先add，在提交

```bash
git add .

git commit -m "add xxx a.txt"
```

### 3. 版本回退

想要撤销提交，使用版本回退，前提是没有提交到远程仓库

查看现在版本

```bash
git log
```

 ![image-20221110142445383](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110142445383.png)

在Git中，上一个版本就HEAD^，上上一个版本就是HEAD^^，当然往上100个版本写100个^比较容易数不过来，所以写成HEAD~100（一般使用id号来恢复）

回到上一个版本

```bash
git reset --hard HEAD^ 
```

可以指定版本

```bash
git reset --hard 6888e4008
```

 ![image-20221110142559892](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110142559892.png)

注：消失的ID号：
回到早期的版本后再查看git log会发现最近的版本消失，可以使用reflog查看消失的版本ID，用于回退到消失的版本

```bash
git reflog
```

### 4. 删除文件

从工作区删除文件，并且从版本库一起删除

从工作区删除

```bash
rm -rf a.txt
```

从版本库删除

```bash
git rm a.txt
```

提交

```bash
git commit -m "删除a.txt"
```

### 5. 将代码上传到仓库master分支

```bash
touch a.txt	#创建新文件
git add a.txt
git commit -m "add a"
git push origin master
```

### 6. 创建分支

在客户端操作

创建分支

```bash
git branch dev
```

查看分支

```bash
git branch
```

切换分支

```bash
git checkout dev

#查看
git branch
```

在dev分支创建文件

```bash
touch b.txt
git add b.txt
git commit -m "add b"
```

切换到 `master` 分支，查看

```bash
git checkout master
ls
```

 ![image-20221110150309092](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110150309092.png)

切换回`master`分支后，再查看一个`test.txt`文件，刚才添加的内容不见了！因为那个提交是在`dev`分支上，而`master`分支此刻的提交点并没有变：

合并分支

```bash
git merg dev
git push origin master
```

 ![image-20221110150623065](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110150623065.png)

合并完成后，查看内容，就可以看到，和`dev`分支的最新提交是完全一样的。

合并完成后，就可以放心地删除`dev`分支了

```bash
git branch -d dev
```



## 2、布署gitlab服务



1、配置yum源

```bash
cd /etc/yum.repos.d/
vi gitlab-ce.repo

[gitlab-ce]
name=Gitlab CE Repository
baseurl=https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el$releasever
gpgcheck=0
enabled=1

#安装相关依赖
yum install -y curl policycoreutils-python openssh-server
systemctl enable sshd
systemctl start sshd

#安装postfix
yum install postfix  #安装邮箱
systemctl enable postfix
systemctl start postfix

yum install -y gitlab-ce-13.1.1-ce.0.el7.x86_64
#安装的版本
yum install -y gitlab-ce
#将会安装gitlab最新版本

#rpm包安装
yum -y install gitlab-ce-13.1.1-ce.0.el7.x86_64.rpm
```

2、配置gitlab

```bash
vim /etc/gitlab/gitlab.rb


# 1.添加对外的域名（gitlab.papamk.com请添加A记录指向本服务器的公网IP）：将原来的修改为
external_url 'http://192.168.1.129'

# 2.设置地区
gitlab_rails['time_zone'] = 'Asia/Shanghai'
```

将数据路径的注释去掉，可以更改

 ![image-20221110185840273](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110185840273.png)

开启ssh服务:

 ![image-20221110185918303](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110185918303.png)

开启邮箱服务

 ![image-20221110190116805](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110190116805.png)

```sh
gitlab_rails['smtp_enable'] = true  #开启smtp服务
gitlab_rails['smtp_address'] = "smtp.163.com" #指定smtp地址
gitlab_rails['smtp_port'] = 465
gitlab_rails['smtp_user_name'] = "xxxx@163.com"  #指定邮箱
gitlab_rails['smtp_password'] = "邮箱授权密码"
gitlab_rails['smtp_domain'] = "163.com"  #邮箱地址的域
gitlab_rails['smtp_authentication'] = "login" 
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = true
gitlab_rails['smtp_openssl_verify_mode'] = 'peer'
gitlab_rails['gitlab_email_from'] = 'xxxx@163.com' #指定发件邮箱
gitlab_rails['gitlab_email_display_name'] = 'Admin' #指定发件人
#user["git_user_email"] = "xxxx@163.com"
```

3、重置并启动GitLab(重新加载，需要等很长时间)

```bash
gitlab-ctl reconfigure
```

 ![image-20221110191028261](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110191028261.png)

4、启动

```bash
gitlab-ctl restart
```

 ![image-20221110191101197](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110191101197.png)

5、邮箱测试

```bash
gitlab-rails console

#测试发送邮件是否成功
irb(main):001:0> Notify.test_email('xxxx@qq.com', 'Message Subject', 'Message Body').deliver_now 

#退出
quit
```

![image-20221110191335893](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110191335893.png)

测试访问：`192.168.1.129`

 ![image-20221110191615667](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110191615667.png)

填写密码8位

![image-20221110191752916](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110191752916.png)

![image-20221110191849804](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110191849804.png)

创建仓库（同github，gitee）

![image-20221110192035430](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110192035430.png)

创建密匙

![image-20221110192358093](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110192358093.png)

客户端操作

```bash
ssh-keygen
cd .ssh/
ls
cat id_rsa.pub

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCk4HniReIdPNtEIGYKv6pmQogQlIT7x0ouDFZDKYuRfeWQvV3CP4Nx5J+KEBBOGiOwXx4iPq2GykTGJWK2XMHG6V9O8HVdxNAVtrPFw+1NDOp8V0UXKVyUVYNJAqNk0AMrAWX5BY/786wj9dgsYkhU/kjkL/cv8x9ZctQ3J8oYAXEHi+I9VXieq8J/77oQ8wnWISNuG37JGQ4Tr9AjhyOoETCo93ULPfbKTyblOr7nhVxJdNrVbwmWHPq5G0JipMQM8owc1pvP2hRTK62CDdJgCjtKdbBK8n6z0zLeVMMid7z/6UceMlnFhZG/up1Lfr3bFSB7VgaBuQAL3cKfhEBz root@git-client
```

![image-20221110192624374](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110192624374.png)

上传文件（同guthub、gitee）

### 1. 创建用户

1、创建一个用户

先退出root用户，在创建

 ![image-20221110193049096](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110193049096.png)

#### 1. 通过邮箱创建用户

首先需要管理员用户登陆gitlab开始创建用户

![image-20221110193611100](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110193611100.png)

> 注意：使用没有注册过的邮箱

这时候创建成功，然后需要通过邮箱发送的地址链接自行进行设置密码。-登陆邮箱

![image-20221110194053999](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110194053999.png)

#### 2. 创建一个组并添加用户到组

![image-20221110194336680](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110194336680.png)

![image-20221110194811995](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110194811995.png)

#### 3. 给组创建一个项目

 ![image-20221110194917331](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110194917331.png)



到此完成，然后将组里面用户的公钥添加到gitlab即可

### 2. 使用 gitlab

```bash
git clone git@192.168.1.129:root/testapp.git
cd testapp/
echo "hello" >> a.txt

git add .
git commit -m "add a"
git push origin master
```

![image-20221110195714244](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221110195714244.png)



## 3、gitlab 备份和恢复

### 1. 查看系统版本和软件版本

```bash
cat /etc/redhat-release

cat /opt/gitlab/embedded/service/gitlab-rails/VERSION
```

### 2. 数据备份

打开 `/etc/gitlab/gitlab.rb` 配置文件，查看一个和备份相关的配置项

```bash
vim /etc/gitlab/gitlab.rb

gitlab_rails['backup_path'] = "/var/opt/gitlab/backups"	#备份的路径
gitlab_rails['backup_archive_permissions'] = 0644		#备份文件的默认权限
gitlab_rails['backup_keep_time'] = 604800				#保留时长，秒为单位 7天
```

![image-20221111141201664](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111141201664.png)

该项定义了默认备份出文件的路径，可以通过修改该配置，并执行 **gitlab-ctl reconfigure 或者 gitlab-ctl  restart** 重启服务生效。

```bash
gitlab-ctl reconfigure
#或者
gitlab-ctl  restart
```

执行备份命令进行备份

```bash
/opt/gitlab/bin/gitlab-rake gitlab:backup:create
```

也可以添加到 crontab 中定时执行

```bash
0 2 * * * /opt/gitlab/bin/gitlab-rake gitlab:backup:create 
```

备份完成，会在备份目录中生成一个当天日期的tar包。

```bash
ls /var/opt/gitlab/backups/
```



### 3. 数据恢复

特别注意：

- 备份目录和gitlab.rb中定义的备份目录必须一致
- GitLab的版本和备份文件中的版本必须一致，否则还原时会报错。

**在恢复之前，可以删除一个文件，以便查看效果**

执行恢复操作

```bash
cd /var/opt/gitlab/backups/
gitlab-rake gitlab:backup:restore BACKUP=1588774133_2020_05_06_12.10.3
#注意恢复文件的名称
```

恢复完成后，或者重启服务，再打开浏览器进行访问，发现数据和之前的一致

```bash
gitlab-ctl  restart
```

> 注意：通过备份文件恢复gitlab必须保证两台主机的gitlab版本一致，否则会提示版本不匹配

## 4、github

