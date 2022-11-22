# Git

## 一、Git是什么

> Git是目前世界上最先进的分布式版本控制系统（没有之一）。
>
> Git有什么特点？简单来说就是：高端大气上档次！
>
> 1、代码管理
>
> 2、版本控制
>
> 3、团队协作

==**代码界的百度云盘**==

## 二、Git安装

> Git可以在Linux/Unix、Solaris、Mac和Windows这几大平台上正常运行
>
> Git各平台下载地址：https://git-scm.com/downloads
>
> - Linux：`sudo apt install git`  `sudo yum install git -y` 
>
>   ​			或者采用编译安装方式：解压源码包，以次输入`./config` , `make` , `sudo make install`
>
> - MacOS：推荐使用homebrew安装：`brew install git`
>
> - Windows：直接下载安装程序安装，使用"Git Bash"



## 三、Git配置

首先要定制你的 Git 环境。 每台计算机上只需要配置一次，程序升级时会保留配置信息。 你可以在任何时候再次通过运行命令来修改它们。

> Git 自带一个 `git config` 的工具来帮助设置控制 Git 外观和行为的配置变量。 这些变量存储在三个不同的位置：
>
> 1. `/etc/gitconfig` 文件: 包含系统上每一个用户及他们仓库的通用配置。 如果使用带有 `--system` 选项的 `git config` 时，它会从此文件读写配置变量。
> 2. `~/.gitconfig` 或 `~/.config/git/config` 文件：只针对当前用户。 可以传递 `--global` 选项让 Git 读写此文件。
> 3. 当前使用仓库的 Git 目录中的 `config` 文件（就是 `.git/config`）：针对该仓库。
>
> 每一个级别覆盖上一级别的配置，所以 `.git/config` 的配置变量会覆盖 `/etc/gitconfig` 中的配置变量。
>
> 在 Windows 系统中，Git 会查找 `$HOME` 目录下（一般情况下是 `C:\Users\$USER`）的 `.gitconfig` 文件。 
>
> Git 同样也会寻找 `/etc/gitconfig` 文件，但只限于 MSys 的根目录下，即安装 Git 时所选的目标位置。

当安装完 Git 应该做的第一件事就是设置你的用户名称与邮件地址。 这样做很重要，因为每一个 Git 的提交都会使用这些信息，并且它会写入到你的每一次提交中，不可更改：

```bash
# 设置提交代码时的用户信息：开始前先设置提交的用户信息，包括用户名和邮箱：
# 如果去掉 --global 参数只对当前仓库有效

git config --global user.name "*****"
git config --global user.email "****@163.com"

# 查看用户名和邮箱是否配置成功
git config --global --list
```

## 四、创建版本库

### 1、什么是版本库

版本库又名仓库，英文名**repository**，你可以简单理解成一个目录，这个目录里面的所有文件都可以被Git管理起来，每个文件的修改、删除，Git都能跟踪，以便任何时刻都可以追踪历史，或者在将来某个时刻可以“还原”。

### 2、创建一个版本库

所以，创建一个版本库非常简单，首先，选择一个合适的地方，创建一个空目录：

```bash
# 新建 works 文件夹，作为项目目录
mkdir works
# 进入 works 目录
cd works
# 显示当前目录（绝对路径）
pwd

# 返回上级目录
cd ..
# 使用 vscode 打开项目目录
code works
```

> :warning: 如果你使用Windows系统，为了避免遇到各种莫名其妙的问题，请确保目录名（包括父目录）不包含中文。

### 3、获取Git仓库

获取Git项目仓库两种方法：

- 在现有目录中初始化仓库
- 从服务器克隆一个现有的Git仓库

#### 在现有目录中初始化仓库

通过`git init`命令把这个目录变成Git可以管理的仓库：

```bash
git init
Initialized empty Git repository in /Users/michael/learngit/.git/
```

> 瞬间Git就把仓库建好了，而且告诉你是一个空的仓库（empty Git repository），细心的读者可以发现当前目录下多了一个`.git`的目录，这个目录是Git来跟踪管理版本库的，没事千万不要手动修改这个目录里面的文件，不然改乱了，就把Git仓库给破坏了。
>
> 如果你没有看到`.git`目录，那是因为这个目录默认是隐藏的，用`ls -ah`命令就可以看见。



## 五、初始化项目



## 六、提交本地仓库到远程仓库







## 七、克隆现有的仓库









































## 旧内容

```bash
1.设置git的username和email：
git config --global user.name "*****"
git config --global user.email "****@163.com"
2.生成并配置密钥/公钥
ssh-keygen -t rsa -C "******@163.com"
ssh-keygen
    在 WSL 下生成 SSH 公钥—私钥对（将邮箱替换为你的邮箱），此时生成的 SSH 密钥默认位于 ~/.ssh 路径下，公钥为 id_rsa.pub，私钥为 id_rsa
3.打开 ssh-agent 使之在后台运行
eval "$(ssh-agent -s)"
4.将私钥添加到 ssh-agent 之中
ssh-add ~/.ssh/id_rsa
5.查看并复制公钥
cat ~/.ssh/id_rsa.pub
6.将复制的公钥信息添加到 Github/Gitee
```



## 代理设置

```bash
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890
```

取消代理

```bash
git config --global --unset http.proxy
git config --global --unset https.proxy
```

