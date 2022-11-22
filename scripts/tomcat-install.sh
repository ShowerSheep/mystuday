#!/bin/bash

[ -f jdk-8u311-linux-x64.tar.gz ] || echo "没有jdk tar包"
tar xf jdk-8u311-linux-x64.tar.gz -C /usr/local/

cat >> /etc/profile.d/jdk.sh <<EOF
export JAVA_HOME=/usr/local/jdk1.8.0_311
export JRE_HOME=\${JAVA_HOME}/jre
export CLASSPATH=.:\${JAVA_HOME}/lib:\${JRE_HOME}/lib
export PATH=\${JAVA_HOME}/bin:\$PATH
EOF

# export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_202
# export JRE_HOME=${JAVA_HOME}/jre
# export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
# export PATH=${JAVA_HOME}/bin:$PATH

source /etc/profile

[ -f apache-tomcat-8.5.83.tar.gz ] || echo "没有Tomcat tar包"
tar xzf apache-tomcat-8.5.83.tar.gz

mv apache-tomcat-8.5.83 /usr/local/tomcat

