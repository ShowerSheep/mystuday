# Jenkins

## 一、布署jenkins服务器

### 0、准备环境

```bash
三台机器：

git-server    ----https://github.com/bingyue/easy-springmvc-maven

jenkins-server    ---192.168.1.131---最好是3个G以上

java-server  	 -----192.168.1.130

https://gitee.com/bingyu076/easy-springmvc-maven.git
```



### 1、安装git客户端

```bash
yum install -y git

ssh-keygen
#拷贝到后端java服务器
ssh-copy-id -i root@192.168.1.130
```

### 2、布署jenkins

```bash
#1.上传jdk
tar xf jdk-8u271-linux-x64.tar.gz -C /usr/local/
cd /usr/local/
mv jdk1.8.0_271/ java

#2.安装tomcat
tar xf apache-tomcat-9.0.68.tar.gz -C /usr/local/
cd /usr/local/
mv apache-tomcat-9.0.68/ tomcat

#3.安装maven
wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
tar xzf apache-maven-3.5.4-bin.tar.gz -C /usr/local/java
cd /usr/local/java
mv apache-maven-3.5.4/ maven

#设置变量
vim /etc/profile.d/maven.sh

JAVA_HOME=/usr/local/java
PATH=$PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin
MAVEN_HOME=/usr/local/java/maven
export JAVA_HOME MAVEN_HOME PATH

source /etc/profile

#验证
java -version

mvn -v
```

### 3、下载 jenkins

官网：http://updates.jenkins-ci.org/download/war/

```bash
wget https://get.jenkins.io/war-stable/2.346.2/jenkins.war --no-check-certificate
```

### 4、布署jenkins

```bash
cd /usr/local/tomcat/webapps/
rm -rf *
cp ~/jenkins.war ./
../bin/startup.sh
```

### 5、访问界面

访问 `192.168.1.131:8080`

#### 1. 错误解决

如果访问出现

![image-20221111152512570](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111152512570.png)

1.解决办法

```bash
cd /usr/local/tomcat/conf/
vim context.xml
#添加
    <Resources
        cachingAllowed="true"
        cacheMaxSize="100000"
    />
```

![image-20221111152606734](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111152606734.png)

重启tomcat

2.如果还是不行

```bash
cd ~/.jenkins/updates/

vim default.json

把 "connectionCheckUrl":"http://www.google.com/" 改为  "connectionCheckUrl":"http://www.baidu.com/"
```

3.要是还是不行

```bash
需要你进入jenkins的工作目录，打开-----hudson.model.UpdateCenter.xml
把http://updates.jenkins-ci.org/update-center.json
改成
http://mirror.xmission.com/jenkins/updates/update-center.json
每次改完记得重启！
```

使用运行war的形式安装jenkins，因为伟大的墙出现，“该jenkins实例似乎已离线” 问题

解决办法

```bash
需要你进入jenkins的工作目录，打开-----hudson.model.UpdateCenter.xml将 url 中的 https://updates.jenkins.io/update-center.json 更改为http://updates.jenkins.io/update-center.json，即去掉 https 中的 s 。
或者更改为https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json
是国内的清华大学的镜像地址。
然后重启tomcat
```



#### 2. 正确

访问 `192.168.1.131:8080`

 ![image-20221111153014676](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111153014676.png)

查看密码

```bash
cat /root/.jenkins/secrets/initialAdminPassword
```

 ![image-20221111153119459](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111153119459.png)

![image-20221111153916501](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111153916501.png)

等待安装

![image-20221111154552858](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111154552858.png)

```bash
admin 
123456 
so@gmail.com
```



### 6、安装插件

![image-20221111170047940](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111170047940.png)

> 安装插件:
> 所需的插件:
> • Maven插件 Maven Integration plugin
> • 发布插件 Deploy to container Plugin
>
> 需要安装插件如下：
> 安装插件
> Deploy to container    ---支持自动化代码部署到tomcat容器
> GIT   可能已经安装
> Maven Integration   :jenkins利用Maven编译，打包所需插件
> Publish Over SSH  :通过ssh连接将打包的war包拷贝到后端服务器
> ssh  插件
> Email Extension Plugin  安装邮件插件
>
> 安装过程:
> 系统管理--->插件管理---->可选插件--->过滤Deploy to container---->勾选--->直接安装

 ![image-20221111170808739](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111170808739.png)

#### 安装gitlab插件

 ![image-20221111170845388](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111170845388.png)



#### 开始配置ssh

 系统管理----系统配置，最下边

key:指的是jenkins服务器用哪个用户去远程连接程序服务器就是那个用户的私钥

```bash
cat ~/.ssh/id_rsa
```

![image-20221111171514039](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111171514039.png)

### 7、添加远程ssh-server

![image-20221111171643716](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111171643716.png)



添加信息

![image-20221111171827481](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111171827481.png)

#### 1. 扩展邮件通知（用于之后项目构建后发送邮件）

添加管理员邮箱地址

 ![image-20221111172241665](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111172241665.png)

向下翻

 ![image-20221114111212552](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114111212552.png)

 ![image-20221114111251932](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114111251932.png)

 ![image-20221114111336225](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114111336225.png)

 ![image-20221114111407508](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114111407508.png)

 ![image-20221114111452266](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114111452266.png)

 ![image-20221114111654624](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114111654624.png)

邮件内容

邮件主题：

```bash
构建通知:${BUILD_STATUS} - ${PROJECT_NAME} - Build # ${BUILD_NUMBER} !
```

邮件内容

```bash
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${ENV, var="JOB_NAME"}-第${BUILD_NUMBER}次构建日志</title>    
</head>    
    
<body leftmargin="8" marginwidth="0" topmargin="8" marginheight="4"    
    offset="0">    
    <table width="95%" cellpadding="0" cellspacing="0"  style="font-size: 11pt; font-family: Tahoma, Arial, Helvetica, sans-serif">    
        <tr>    
            本邮件由系统自动发出，无需回复！<br/>            
            各位同事，大家好，以下为${PROJECT_NAME }项目构建信息</br> 
            <td><font color="#CC0000">构建结果 - ${BUILD_STATUS}</font></td>   
        </tr>    
        <tr>    
            <td><br />    
            <b><font color="#0B610B">构建信息</font></b>    
            <hr size="2" width="100%" align="center" /></td>    
        </tr>    
        <tr>    
            <td>    
                <ul>    
                    <li>项目名称 ： ${PROJECT_NAME}</li>    
                    <li>构建编号 ： 第${BUILD_NUMBER}次构建</li>    
                    <li>触发原因： ${CAUSE}</li>    
                    <li>构建状态： ${BUILD_STATUS}</li>    
                    <li>构建日志： <a href="${BUILD_URL}console">${BUILD_URL}console</a></li>    
                    <li>构建  Url ： <a href="${BUILD_URL}">${BUILD_URL}</a></li>    
                    <li>工作目录 ： <a href="${PROJECT_URL}ws">${PROJECT_URL}ws</a></li>    
                    <li>项目  Url ： <a href="${PROJECT_URL}">${PROJECT_URL}</a></li>    
                </ul>    

<h4><font color="#0B610B">失败用例</font></h4>
<hr size="2" width="100%" />
$FAILED_TESTS<br/>

<h4><font color="#0B610B">最近提交(#$SVN_REVISION)</font></h4>
<hr size="2" width="100%" />
<ul>
${CHANGES_SINCE_LAST_SUCCESS, reverse=true, format="%c", changesFormat="<li>%d [%a] %m</li>"}
</ul>
详细提交: <a href="${PROJECT_URL}changes">${PROJECT_URL}changes</a><br/>

            </td>    
        </tr>    
    </table>    
</body>    
</html>
```

 ![image-20221114111903164](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114111903164.png)

#### 2. 设置邮箱触发器

 ![image-20221114112008975](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114112008975.png)

展开选项，选择`Always`

 ![image-20221114112355921](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114112355921.png)

![image-20221114112429782](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114112429782.png)

点击最下方 应用 保存



### 8、配置jdk，maven命令，git全局配置

系统管理---全局工具配置

 ![image-20221111173038090](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111173038090.png)

 ![image-20221111173305316](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111173305316.png)

 ![image-20221111173326816](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221111173326816.png)

### 9、构建发布任务

 ![image-20221114112850597](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114112850597.png)

 ![image-20221114112922247](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114112922247.png)

 ![image-20221114113048255](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114113048255.png)

![image-20221114145755920](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114145755920.png)

 ![image-20221114145815462](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114145815462.png)

 ![image-20221114145901789](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114145901789.png)



### 10、调用maven命令

 ![image-20221114145932192](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114145932192.png)

![image-20221114150023077](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114150023077.png)

 ![image-20221114150126942](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114150126942.png)



### 11、部署java服务器，做jenkins打包上线

```bash
mkdir -p /data/application

#上传jdk
tar xf jdk-8u271-linux-x64.tar.gz -C /usr/local/
mv /usr/local/jdk1.8.0_271/ /usr/local/java

#上传Tomcat
tar xf apache-tomcat-9.0.68.tar.gz -C /data/application/
mv /data/application/apache-tomcat-9.0.68/ /data/application/tomcat

#添加环境变量
vim /etc/profile.d/tomcat.sh

export JAVA_HOME=/usr/local/java
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib:$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar
export TOMCAT_HOME=/data/application/tomcat

source /etc/profile

#删除原发布目录内容
rm -rf /data/application/tomcat/webapps/*

#创建脚本
mkdir /opt/script
touch /opt/script/jenkins.sh
chmod +x jenkins.sh
```

`jenkins.sh` 脚本

```sh
#!/usr/bin/bash
#本脚本适用于jenkins持续集成，实现备份war包到代码更新上线！使用时请注意全局变量。
#================
#Defining variables
export JAVA_HOME=/usr/local/java
webapp_path="/data/application/tomcat/webapps"
tomcat_run="/data/application/tomcat/bin"
updata_path="/data/update/`date +%F-%T`"
backup_path="/data/backup/`date +%F-%T`"
tomcat_pid=`ps -ef | grep tomcat | grep -v grep | awk '{print $2}'`
files_dir="easy-springmvc-maven"
files="easy-springmvc-maven.war"
job_path="/root/upload"

#Preparation environment
echo "Creating related directory"
mkdir -p $updata_path
mkdir -p $backup_path

echo "Move the uploaded war package to the update directory"
mv $job_path/$files $updata_path

echo "========================================================="
cd /opt
echo "Backing up java project"
if [ -f $webapp_path/$files ];then
	tar czf $backup_path/`date +%F-%H`.tar.gz $webapp_path
	if [ $? -ne 0 ];then
		echo "打包失败，自动退出"
		exit 1
	else
		echo "Checking if tomcat is started"
		if [ -n "$tomcat_pid" ];then
			kill -9 $tomcat_pid
			if [ $? -ne 0 ];then
				echo "tomcat关闭失败，将会自动退出"
				exit 2
			fi
		fi
		cd $webapp_path
		rm -rf $files && rm -rf $files_dir
		cp $updata_path/$files $webapp_path
		cd /opt
		$tomcat_run/startup.sh
		sleep 5
		echo "显示tomcat的pid"
		echo "`ps -ef | grep tomcat | grep -v grep | awk '{print $2}'`"
		echo "tomcat startup"
		echo "请手动查看tomcat日志。脚本将会自动退出"
	fi
else
	echo "Checking if tomcat is started"
        if [ -n "$tomcat_pid" ];then
        	kill -9 $tomcat_pid
                if [ $? -ne 0 ];then
                	echo "tomcat关闭失败，将会自动退出"
                       	exit 2
                fi
        fi
	cp $updata_path/$files $webapp_path
	$tomcat_run/startup.sh
        sleep 5
        echo "显示tomcat的pid"
        echo "`ps -ef | grep tomcat | grep -v grep | awk '{print $2}'`"
        echo "tomcat startup"
        echo "请手动查看tomcat日志。脚本将会自动退出"
fi
```

### 12、开始构建任务

![image-20221114151858585](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114151858585.png)

 ![image-20221114151930180](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114151930180.png)

 ![image-20221114151952919](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114151952919.png)

![image-20221114152019724](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114152019724.png)

查看构建结果

 ![image-20221114152043040](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114152043040.png)



## 二、参数化构建实现版本回退

通过回滚git仓库的版本号实现

### 1、git远程仓库

```bash
yum -y install git

#创建git仓库
mkdir /git-test

#创建git用户，密码
useradd git
passwd git

#设置为远程仓库
cd /git-test/
git init --bare pm-test
chown git.git /git-test/ -R
```

### 2、java-web后端服务器

```bash
ssh-keygen

#将密匙传给git服务器的git用户
ssh-copy-id -i git@192.168.1.136

#克隆远程仓库
git clone git@192.168.1.136:/git-test/pm-test
```

模拟提交代码

```bash
git config --global user.email "soho@163.com"
git config --global user.name "soho"

#下载示例源代码
git clone https://gitee.com/bingyu076/easy-springmvc-maven.git
cp -r easy-springmvc-maven/* pm-test/
cd pm-test/

#提交到远程仓库
git add .
git commit -m "the first copy"
git push origin master
```

### 3、配置jenkins页面

 ![image-20221114172401391](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114172401391.png)

 ![image-20221114172439723](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114172439723.png)

 勾选 `This project is parameterized` ，参数化构建

 ![image-20221114173631907](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114173631907.png)

选择 `choice Parameter` ，选项参数

 ![image-20221114174009164](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114174009164.png)

option：定义的变量，脚本里面通过case判断传递参数

```bash
deploy
rollback

deploy：发布
rollback：回滚
```



 ![image-20221114174226430](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114174226430.png)

选择 `String Parameter` 字符参数

 ![image-20221114174626319](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114174626319.png)

```bash
回滚请输入版本号，（例如，3）
发布请忽略该选项
```



![image-20221114174817342](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114174817342.png)

 ![image-20221114174925751](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114174925751.png)

在 `jenkins-server` 查看

```bash
cat ~/.ssh/id_rsa
```

 ![image-20221114175155702](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114175155702.png)

 ![image-20221114175309398](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114175309398.png)

将jenkins服务器上面的root用户的公钥添加到git服务的git用户中

```bash
ssh-copy-id -i git@192.168.1.136
```

界面已经OK

 ![image-20221114190148238](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114190148238.png)

 ![image-20221114190208230](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114190208230.png)

#### 添加执行shell命令

 ![image-20221114190319242](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114190319242.png)

或者选择 `Execute shell`

 ![image-20221114190507022](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114190507022.png)

```bash
bash /opt/script/version.sh $option $version
```

  ![image-20221114190635885](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114190635885.png)

 ![image-20221114190808777](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114190808777.png)

#### 定义ssh传输命令

 ![image-20221114190919865](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114190919865.png)

去java后端服务器修改脚本

```bash
vim /opt/script/jenkins.sh
```

```sh
#!/usr/bin/bash
#本脚本适用于jenkins持续集成，实现备份war包到代码更新上线！使用时请注意全局变量。
#================
#Defining variables
export JAVA_HOME=/usr/local/java
webapp_path="/data/application/tomcat/webapps"
tomcat_run="/data/application/tomcat/bin"
updata_path="/data/update/`date +%F-%T`"
backup_path="/data/backup/`date +%F-%T`"
tomcat_pid=`ps -ef | grep tomcat | grep -v grep | awk '{print $2}'`
#files_dir="easy-springmvc-maven"  #注释掉
files="*.war" #修改为*.war
job_path="/root/upload"

#Preparation environment
echo "Creating related directory"
mkdir -p $updata_path
mkdir -p $backup_path

echo "Move the uploaded war package to the update directory"
mv $job_path/$files $updata_path

echo "========================================================="
cd /opt
echo "Backing up java project"
if [ -f $webapp_path/$files ];then
        tar czf $backup_path/`date +%F-%H`.tar.gz $webapp_path
        if [ $? -ne 0 ];then
                echo "打包失败，自动退出"
                exit 1
        else
                echo "Checking if tomcat is started"
                if [ -n "$tomcat_pid" ];then
                        kill -9 $tomcat_pid
                        if [ $? -ne 0 ];then
                                echo "tomcat关闭失败，将会自动退出"
                                exit 2
                        fi
                fi
                cd $webapp_path
                rm -rf $files && rm -rf *  #这里也需要修改
                cp $updata_path/$files $webapp_path
                cd /opt
                $tomcat_run/startup.sh
                sleep 5
                echo "显示tomcat的pid"
                echo "`ps -ef | grep tomcat | grep -v grep | awk '{print $2}'`"
                echo "tomcat startup"
                echo "请手动查看tomcat日志。脚本将会自动退出"
        fi
else
        echo "Checking if tomcat is started"
        if [ -n "$tomcat_pid" ];then
                kill -9 $tomcat_pid
                if [ $? -ne 0 ];then
                        echo "tomcat关闭失败，将会自动退出"
                        exit 2
                fi
        fi
        cp $updata_path/$files $webapp_path
        $tomcat_run/startup.sh
        sleep 5
        echo "显示tomcat的pid"
        echo "`ps -ef | grep tomcat | grep -v grep | awk '{print $2}'`"
        echo "tomcat startup"
        echo "请手动查看tomcat日志。脚本将会自动退出"
fi
```

 ![image-20221114191335194](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114191335194.png)

 ![image-20221114191613596](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114191613596.png)



在jenkins-server服务器写脚本

```bash
vim /opt/script/version.sh
```

```sh
#!/bin/bash
#本脚本用于参数化构建,项目发布与版本回滚,请慎用!
#============================
#time 2018.08
#Author 轩哥
#----------------------------------------------
deploy(){
echo "deploy: $option"
cd $WORKSPACE
git rev-parse HEAD >> $WORKSPACE/version.log
}
rollback(){
Newversion=`expr $version + 1`
Head=`tail -n $Newversion $WORKSPACE/version.log | head -n 1`
cd $WORKSPACE
git rev-parse HEAD >> $WORKSPACE/version.log
git reset --hard $Head
}

case $option in
deploy)
deploy
;;
rollback)
rollback
;;
*)
echo $"Usage: {deploy|rollback}" 
exit 1
;;
esac
```

```bash
chmod +x /opt/script/version.sh
```

回到jenkins页面发布

 ![image-20221114191949665](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114191949665.png)

查看控制台输出

#### 查看服务器

Jenkins服务器，查看版本号

```bash
cd ~/.jenkins/workspace/pm-test
cat version.log
```

 ![image-20221114192929753](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114192929753.png)

查看后端服务器

```bash
cd /data/application/tomcat/webapps/
```

![image-20221114193052817](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114193052817.png)

再次构建新版本的war包

> 注意：为了区分，这里重新找了一个源代码重新上传到仓库中去。
>
> `yuyinClient.zip` 为例

```bash
#解压新的项目文件
unzip yuyinClient.zip

git clone git@192.168.1.136:/git-test/pm-test

#删除原有的代码文件
rm -rf *

#拷贝新的代码文件
cp -R /root/yuyinClient/* .

#提交代码到远程仓库
git add -A
git commit -m "change all file"
git push origin master
```

重新开始构建项目

 ![image-20221114194058287](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114194058287.png)

查看构建结果是否成功

在后端服务器查看

```bash
#查看是否构建成功
ls /data/application/tomcat/webapps/

#查看是否备份成功
ls /data/backup/
```

 ![image-20221114194919924](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114194919924.png)

### 4、开始回滚

jenkins服务器查看版本号

```bash
cd /root/.jenkins/workspace/pm-test
cat version.log
```

 ![image-20221114195436348](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114195436348.png)

回滚

 ![image-20221114195521734](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221114195521734.png)

去后端服务器查看

```bash
ls /data/application/tomcat/webapps
```

查看是否返回上个版本



## 三、gitlab webhook + jenkins 实现代码自动化发布

### 1、gitlab部署

略

user:admin password:12345678

创建一个`project` ，例如：testweb

![image-20221115144446535](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115144446535.png)



### 2、构建项目

 ![image-20221115144812141](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115144812141.png)

 ![image-20221115144839954](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115144839954.png)

填写gitlab仓库地址

![image-20221115144907967](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115144907967.png)

 ![image-20221115144939728](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115144939728.png)

jenkins操作

```bash
useradd jenkins
su - jenkins
ssh-keygen
cat .ssh/id_rsa
```

把私匙填入key

 ![image-20221115145232966](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115145232966.png)

 ![image-20221115145253205](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115145253205.png)

### 3、gitlab添加jenkins用户公钥

 ![image-20221115145408271](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115145408271.png)

jenkins-server切换到jenkins用户

```bash
cat .ssh/id_rsa.pub

#使用昉检测链接
ssh root@192.168.1.129 -o StrictHostKeyChecking=no
```

### 4、构建触发器

 ![image-20221115145733092](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115145733092.png)

 ![image-20221115145948030](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115145948030.png)

![image-20221115150012552](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115150012552.png)

### 5、gitlab配置webhook

![image-20221115151751715](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115151751715.png)

![image-20221115151825547](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115151825547.png)

添加完成之后baocuo

 ![image-20221115151858873](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115151858873.png)

这是因为gitlab 10.6 版本以后为了安全，不允许向本地网络发送webhook请求，设置如下

 ![image-20221115152005797](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115152005797.png)

![image-20221115152436554](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115152436554.png)

### 6、重新添加webhook

 ![image-20221115152637390](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115152637390.png)

### 7、测试

jenkins配置，应用--->保存

在后端服务器测试，把公钥添加到gitlab

```bash
ssh-keygen
cat .ssh/id_rsa.pub
```

克隆代码，模拟提交

```bash
git clone git@192.168.1.129:root/testweb.git

touch a.txt

git add .
git commit -m "1111"
git push origin master
```

返回 jenkins页面查看自动发布情况

查看控制台输出

![image-20221115153345573](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115153345573.png)



## 四、pipeline流水线

安装 pipline 插件：Pipeline.  默认已经安装

### 0、pipeline介绍

声明式语法

```groovy
pipeline { ：开头声明此脚本是 Declarative式脚本

agent any ：模块一，此处填写构建pipeline的环境，机器，docker环境，kubernetes环境

stages：模块二，阶段记录所有步骤，代表构建项目的阶段开头

stage：阶段步骤，一个 stages 中包含多个 stage，对应 拉取代码、编译打包、部署发布等等

steps：步骤实现，具体实现该步骤的命令，如何通过编写来实现步骤
```

语法案例

```groovy
pipeline {
 agent any  #指定运行pipeline的节点。any任意节点。

 stages {  			#开始一个项目构建
  stage('pull code') { 	#第一步拉取代码 
   steps {    	#具体实施步骤
    echo 'pull code' 	#拉取代码命令
   }
  }
  stage('build project') {		#第二步编译打包 
   steps {   		 	#具体实施步骤
    echo 'build project' 	 	#打包命令
   }
  }
  stage('publish project') { 		#部署上线 
   steps {    		#具体实施步骤
    echo 'publish project' 	#部署命令
   }
  }
 }
}
```

### 1、创建一个流水线项目

 ![image-20221115165550521](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115165550521.png)

![image-20221115165716923](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115165716923.png)

![image-20221115170332438](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115170332438.png)

![image-20221115165845100](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115165845100.png)

![image-20221115170134355](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115170134355.png)

![image-20221115170154597](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115170154597.png)

![image-20221115170518226](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115170518226.png)

```groovy
checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'e89b7c69-55f0-4cdb-adcb-41a426239621', url: 'git@192.168.1.129:root/testweb.git']]])
```



![image-20221115170843934](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20221115170843934.png)

紧接着发布到后端服务器最后发送邮件--完整的配置如下

```groovy
pipeline {
    agent any

    stages {
        stage('pull code') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'e89b7c69-55f0-4cdb-adcb-41a426239621', url: 'git@192.168.1.129:root/testweb']]])
            }
        }
        stage('build project') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('deploy project') {
            steps {
                sh 'ssh root@192.168.1.130 "mkdir -p /root/upload"'
                sh 'scp -r /root/.jenkins/workspace/test1/target/easy-springmvc-maven.war 192.168.1.130:/root/upload'
                sh 'ssh root@192.168.1.130 "bash /opt/script/jenkins.sh"'
            }
        }
        stage('send mail') {
            steps {
                emailext body: '''${ENV, var="JOB_NAME"}-第${BUILD_NUMBER}次构建日志
各位同事，大家好，以下为${PROJECT_NAME }项目构建信息
构建结果 - ${BUILD_STATUS}
项目名称 - ${PROJECT_NAME}    
构建编号 ： 第${BUILD_NUMBER}次构建
触发原因： ${CAUSE}  
构建状态： ${BUILD_STATUS}
构建日志： ${BUILD_URL}
构建Url ： ${BUILD_URL}
工作目录： ${PROJECT_URL}
项目Url ： ${PROJECT_URL}
              ''', subject: '构建通知:${BUILD_STATUS} - ${PROJECT_NAME} - Build', to: 'xxx@qq.com'
            }
        }
    }
}
```

