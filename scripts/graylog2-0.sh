#!/bin/bash
#############################################################
# Graylog V2.2
# Ubuntu 14.04.05
# Update: 1/6/2017
# Author: ManhDV
#############################################################
# Run with root account  
# wget 
# bash graylog-server.sh
# Wait ....join

###############################
# Get IP Server
#IPADD="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"
echo -e "\033[32m  ##### Enter IP for Graylog server (Nhap IP cho Graylog) ##### \033[0m"
read -r IPADD
echo -e "\033[33m  ##### Script install Graylog V2.x (Script cai dat Graylog V2.x) ###### \033[0m"
sleep 3
echo -e "\033[32m  ##### Enter password for Graylog server (Nhap password cho Graylog) ##### \033[0m"
read -r adminpass
###############################
echo -e "\033[33m ##### Update repos packages Elasticsearch, MongoDB, Graylog \033[0m"
sleep 3
#Cai dat Java 8
add-apt-repository ppa:openjdk-r/ppa <<EOF

EOF

apt-get update -y
apt-get install -y apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen git wget 

echo JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"  | tee -a /etc/environment
source /etc/environment

# For Elasticsearch
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
apt-get update && apt-get -y install elasticsearch
cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.bak
sed -i 's/# cluster.name: my-application/cluster.name: graylog/g' /etc/elasticsearch/elasticsearch.yml
update-rc.d elasticsearch defaults
service elasticsearch restart
# For MongoDB
apt-get install -y mongodb-server
service mongodb restart
# Test connection
while ! nc -vz localhost 27017; do sleep 1; done
echo -e "\033[33m ##### Install sussces MONGODB ##### \033[0m"
sleep 3

# For Graylog 2.x
echo -e "\033[33m  ##### Install Graylog V2.x Server##### \033[0m"
wget http://packages.graylog2.org/repo/packages/graylog-2.2-repository_latest.deb
dpkg -i graylog-2.2-repository_latest.deb
apt-get update && apt-get -y install graylog-server
sleep 3

cp /etc/graylog/server/server.conf /etc/graylog/server/server.conf.bak
pass_secret=$(pwgen -s 96)
sed -i -e 's|password_secret =|password_secret = '$pass_secret'|' /etc/graylog/server/server.conf
admin_hash=$(echo -n $adminpass | shasum -a 256 | awk '{print $1}')
sed -i -e "s|root_password_sha2 =|root_password_sha2 = $admin_hash|" /etc/graylog/server/server.conf
sed -i 's|#root_timezone = UTC|root_timezone = Asia/Ho_Chi_Minh|' /etc/graylog/server/server.conf
sed -i "s|rest_listen_uri = http:\/\/127.0.0.1:9000\/api\/|rest_listen_uri = http:\/\/$IPADD:9000\/api\/|g" /etc/graylog/server/server.conf
sed -i "s|#web_listen_uri = http:\/\/127.0.0.1:9000\/|web_listen_uri = http:\/\/$IPADD:9000|" /etc/graylog/server/server.conf
sed -i -e 's|elasticsearch_shards = 4|elasticsearch_shards = 1|' /etc/graylog/server/server.conf
sed -i 's|retention_strategy = delete|retention_strategy = close|' /etc/graylog/server/server.conf
rm -f /etc/init/graylog-server.override
update-rc.d graylog-server defaults
service graylog-server start

#################
echo -e "\033[32m Setup Complete!"
echo "You can access Graylog Server by IP $IPADD:9000"
echo "User: admin"
echo "Pass: $adminpass"
echo -e "\033[0m"
echo "Rebooting "
sleep 10
init 6