#!/bin/sh

apt-get install shadowsocks
#TODO
ssserver -c /etc/shadowsocks/config.json -d start

echo net.ipv4.tcp_fastopen = 3 >> /etc/sysctl.conf
sysctl -p # /proc/sys/net/ipv4/tcp_fastopen
