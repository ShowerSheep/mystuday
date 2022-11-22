#!/bin/bash
cat <<-EOF
本脚本将按顺序执行如下步骤：
1.关闭防火墙,seLinux
2.换aliyun源，重建缓存
3.安装 vim wget zsh unzip net-tools ntpdate git psmisc patch tree
4.安装开发者工具组包
5.定时5min时间同步
6.最大文件打开数量
EOF

echo "1.关闭防火墙，seLinux"
systemctl stop firewalld && systemctl disable firewalld
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

echo "2.换aliyun源，重建缓存"
rm -rf /etc/yum.repos.d/*
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo
yum clean all
rm -rf /var/cache/yum/
yum makecache fast

echo "3.安装必要软件"
yum -y install vim wget zsh unzip net-tools ntpdate git psmisc patch tree

echo "4.安装常用依赖环境"
yum groupinstall "Development Tools" -y


echo "5.定时5min时间同步"
ntpdate ntp1.aliyun.com
cat >>/var/spool/cron/root<<EOF
*/5 * * * * /usr/sbin/ntpdate ntp1.aliyun.com &>/dev/null
EOF

echo "6.最大文件打开数量"
cat>>/etc/security/limits.d/20-nproc.conf <<EOF
*       soft nproc 65536
*       hard nproc 65536
*       soft nofile 65536
*       hard nofile 65536
EOF


# 释放缓存中的内存
# echo 3 >/proc/sys/vm/drop_caches

rm -f new-system.sh