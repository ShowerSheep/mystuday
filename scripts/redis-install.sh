wget http://download.redis.io/releases/redis-4.0.9.tar.gz

tar xzf redis-4.0.9.tar.gz

cd redis-4.0.9

yum install -y gcc make
make PREFIX=/usr/local/redis  install

cp redis.conf  /usr/local/redis

echo "export PATH=\$PATH:/usr/local/redis/bin" >> ~/.bashrc

source ~/.bashrc

cat >/usr/lib/systemd/system/redis.service<<EOF
[Unit]
Description=The redis-server Process Manager
After=syslog.target network.target

[Service]
Type=simple
PIDFile=/var/run/redis_6379.pid
ExecStartPost=/bin/sleep 0.1
ExecStart=/usr/local/redis/bin/redis-server  /usr/local/redis/redis.conf
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStop=/bin/kill -s QUIT \$MAINPID

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable redis