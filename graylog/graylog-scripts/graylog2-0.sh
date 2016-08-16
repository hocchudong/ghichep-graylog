#!/bin/bash
#############################################################
# Graylog V2.x
# Ubuntu 14.04.1
# Update: 24/5/2016
# Author: ManhDV
#############################################################
# Run with root account  
# wget 
# bash graylog-server.sh
# Wait ....join

###############################
# Get IP Server
IPADD="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"

echo -e "\033[33m  ##### Script install Graylog V2.x (Script cai dat Graylog V2.x) ###### \033[0m"
sleep 3
echo -e "\033[32m  ##### Enter password for Graylog server (Nhap password cho Graylog) ##### \033[0m"
read -r adminpass
###############################
echo -e "\033[33m ##### Update repos packages Elasticsearch, MongoDB, Graylog \033[0m"
sleep 3
# For Elasticsearch
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
# For MongoDB
apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
# For Graylog 2.x
apt-get -y install apt-transport-https
wget https://packages.graylog2.org/repo/packages/graylog-2.0-repository_latest.deb
sudo dpkg -i graylog-2.0-repository_latest.deb
# Update
apt-get update
apt-get -y install git curl build-essential pwgen wget ssh ntp
#Install Open-JDK
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install openjdk-8-jdk -y

echo JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"  | tee -a /etc/environment
source /etc/environment
########################
# Install software basic
apt-get -y install git curl build-essential pwgen wget ssh ntp

# Install elasticsearch
echo -e "\033[33m ##### Install elasticsearch ##### \033[0m"
sleep 3
sudo apt-get install elasticsearch

cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.bak
sed -i -e 's|# cluster.name: my-application|cluster.name: graylog|' /etc/elasticsearch/elasticsearch.yml
sed -i -e 's|# discovery.zen.ping.unicast.hosts: \["host1", "host2"\]|discovery.zen.ping.unicast.hosts: ['\"127.0.0.1:9300\"']|' /etc/elasticsearch/elasticsearch.yml


mv /etc/security/limits.conf /etc/security/limits.bak
grep -Ev "# End of file" /etc/security/limits.bak > /etc/security/limits.conf
echo "elasticsearch soft nofile 32000" >> /etc/security/limits.conf
echo "elasticsearch hard nofile 32000" >> /etc/security/limits.conf
echo "# End of file" >> /etc/security/limits.conf

echo "#### Restart elasticsearch ####"
sleep 3
service elasticsearch restart
update-rc.d elasticsearch defaults
# Install Mongodb
echo -e "\033[33m ##### Install Mongodb ##### \033[0m"
sleep 3
apt-get install -y mongodb-org

# Start mongodb
service mongod start

# Test connection
while ! nc -vz localhost 27017; do sleep 1; done

echo -e "\033[33m ##### Install sussces MONGODB ##### \033[0m"
sleep 3
# Download Graylog 2.x
echo -e "\033[33m  ##### Install Graylog V2.x Server##### \033[0m"
sleep 3
sudo apt-get install graylog-server

cp /etc/graylog/server/server.conf /etc/graylog/server/server.conf.bak
pass_secret=$(pwgen -s 96)
sed -i -e 's|password_secret =|password_secret = '$pass_secret'|' /etc/graylog/server/server.conf
admin_hash=$(echo -n $adminpass | shasum -a 256 | awk '{print $1}')
sed -i -e "s|root_password_sha2 =|root_password_sha2 = $admin_hash|" /etc/graylog/server/server.conf
sed -i 's|#root_timezone = UTC|root_timezone = Asia/Ho_Chi_Minh|' /etc/graylog/server/server.conf
sed -i -e 's|rest_listen_uri = http://127.0.0.1:12900/|rest_listen_uri = http://0.0.0.0:12900/|' /etc/graylog/server/server.conf
sed -i -e 's|elasticsearch_shards = 4|elasticsearch_shards = 1|' /etc/graylog/server/server.conf
sed -i -e 's|#elasticsearch_discovery_zen_ping_multicast_enabled = false|elasticsearch_discovery_zen_ping_multicast_enabled = false|' /etc/graylog/server/server.conf
sed -i -e 's|#elasticsearch_discovery_zen_ping_unicast_hosts = 127.0.0.1:9300, 127.0.0.2:9500|elasticsearch_discovery_zen_ping_unicast_hosts = '127.0.0.1:9300'|' /etc/graylog/server/server.conf
sed -i 's|retention_strategy = delete|retention_strategy = close|' /etc/graylog/server/server.conf
sed -i -e 's|#web_listen_uri = http://127.0.0.1:9000/|web_listen_uri = http://0.0.0.0:9000|' /etc/graylog/server/server.conf
sudo start graylog-server
echo -e "\033[33m ##### Configuring rsyslog ##### \033[0m"
sleep 3 

sed -i -e 's|#$ModLoad imudp|$ModLoad imudp|' /etc/rsyslog.conf
sed -i -e 's|#$UDPServerRun 514|$UDPServerRun 514|' /etc/rsyslog.conf
sed -i -e 's|#$ModLoad imtcp|$ModLoad imtcp|' /etc/rsyslog.conf
sed -i -e 's|#$InputTCPServerRun 514|$InputTCPServerRun 514|' /etc/rsyslog.conf
sed -i -e 's|*.*;auth,authpriv.none|#*.*;auth,authpriv.none|' /etc/rsyslog.d/50-default.conf
echo '$template GRAYLOG,"<%pri%>1 %timegenerated:::date-rfc3339% %fromhost% %app-name% %procid% %msg%\n"'  | tee -a /etc/rsyslog.d/32-graylog.conf
echo '$PreserveFQDN on' | tee -a  /etc/rsyslog.d/32-graylog.conf
echo '*.* @localhost:10514;GRAYLOG' | tee -a  /etc/rsyslog.d/32-graylog.conf
echo "##### Restarting rsyslog #####"
service rsyslog restart
#################
echo -e "\033[32m Setup Complete!"
echo "You can access Graylog Server by IP $IPADD:9000"
echo "User: admin"
echo "Pass: $adminpass"
echo -e "\033[0m"
echo "Rebooting "
sleep 10
init 6

