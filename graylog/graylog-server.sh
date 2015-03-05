#!/bin/bash
#############################################################
#
# Graylog V1.0
# Ubuntu 14.04.1
# Update: 03/03/2015
# Author: Congto / TW: @tothanhcong
#############################################################

###############################
# Get IP Server
IPADD_ETH0="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"

echo "##### Script install Graylog V1.0 (Script cai dat Graylog V1.0) ######"
sleep 3
echo "##### Enter password for Graylog server (Nhap password cho Graylog) #####"
read adminpass

###############################
echo "##### Update repos packages Elasticsearch, MongoDB,Graylog "
sleep 3
# For Elasticsearch
wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
echo 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main' | sudo tee /etc/apt/sources.list.d/elasticsearch.list

# For MongoDB
apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

# For Graylog
wget https://packages.graylog2.org/repo/packages/graylog-1.0-repository-ubuntu14.04_latest.deb
dpkg -i graylog-1.0-repository-ubuntu14.04_latest.deb
apt-get install apt-transport-https

# Update
apt-get update

########################
# Install software basic
apt-get -y install git curl build-essential openjdk-7-jre pwgen wget ssh ntp

# Install elasticsearch
sudo apt-get install elasticsearch
sed -i -e 's|#cluster.name: elasticsearch|cluster.name: graylogcluster|' /etc/elasticsearch/elasticsearch.yml
sed -i -e 's|#transport.tcp.port: 9300|transport.tcp.port: 9300|' /etc/elasticsearch/elasticsearch.yml
sed -i -e 's|#http.port: 9200|http.port: 9200|' /etc/elasticsearch/elasticsearch.yml

echo "#### Restart elasticsearch ####"
sleep 3
service elasticsearch restart

# Install Mongodb
apt-get install -y mongodb-org

# Start mongodb
service mongod start

# Test connection
while ! nc -vz localhost 27017; do sleep 1; done

echo "##### Install sussces MONGODB #####"
sleep 3

# Download Graylog2 tarballs
echo "##### Install Graylog1.0 #####"
apt-get install graylog-server graylog-web

echo "##### Config Graylog server #####"
sleep 3
pass_secret=$(pwgen -s 96)
sed -i -e 's|password_secret =|password_secret = '$pass_secret'|' /etc/graylog/server/server.conf
admin_hash=$(echo -n $adminpass | sha256sum -a 256 | awk '{print $1}')
sed -i -e "s|root_password_sha2 =|root_password_sha2 = $admin_hash|" /etc/graylog/server/server.conf
sed -i 's|#root_timezone = UTC|root_timezone = Asia/Ho_Chi_Minh|' /etc/graylog/server/server.conf
sed -i -e 's|#rest_transport_uri = http://192.168.1.1:12900/|rest_transport_uri = http://127.0.0.1:12900/|' /etc/graylog/server/server.conf
sed -i -e 's|elasticsearch_shards = 4|elasticsearch_shards = 1|' /etc/graylog/server/server.conf
sed -i -e 's|#elasticsearch_cluster_name = graylog2|#elasticsearch_cluster_name = graylogcluster|' /etc/graylog/server/server.conf
sed -i -e 's|#elasticsearch_discovery_zen_ping_multicast_enabled = false|elasticsearch_discovery_zen_ping_multicast_enabled = false|' /etc/graylog/server/server.conf
sed -i -e 's|#elasticsearch_discovery_zen_ping_unicast_hosts = 192.168.1.203:9300|elasticsearch_discovery_zen_ping_unicast_hosts = 127.0.0.1:9300|' /etc/graylog/server/server.conf
sed -i -e 's|mongodb_useauth = true|mongodb_useauth = false|' /etc/graylog/server/server.conf
sed -i 's|retention_strategy = delete|retention_strategy = close|' /etc/graylog/server/server.conf


service graylog-server start
echo "Waiting for Graylog server to start!"
# while ! nc -vz localhost 12900; do sleep 1; done

echo "##### Configuring Graylog Web interface #####"
sleep 3
sed -i -e 's|graylog2-server.uris=""|graylog2-server.uris="http://127.0.0.1:12900/"|' /etc/graylog/web/web.conf
app_secret=$(pwgen -s 96)
sed -i -e 's|application.secret=""|application.secret="'$app_secret'"|' /etc/graylog/web/web.conf
sed -i -e 's|# timezone="Europe/Berlin"|timezone="Asia/Ho_Chi_Minh"|' /etc/graylog/web/web.conf
service graylog-web start

echo "##### Configuring rsyslog #####"
sleep 3 

sed -i -e 's|#$ModLoad imudp|$ModLoad imudp|' /etc/rsyslog.conf
sed -i -e 's|#$UDPServerRun 514|$UDPServerRun 514|' /etc/rsyslog.conf
sed -i -e 's|#$ModLoad imtcp|$ModLoad imtcp|' /etc/rsyslog.conf
sed -i -e 's|#$InputTCPServerRun 514|$InputTCPServerRun 514|' /etc/rsyslog.conf
sed -i -e 's|*.*;auth,authpriv.none|#*.*;auth,authpriv.none|' /etc/rsyslog.d/50-default.conf
echo '$template GRAYLOG,"<%pri%>1 %timegenerated:::date-rfc3339% %fromhost% %app-name% %procid% %msg%\n"'  | tee -a /etc/rsyslog.d/32-graylog.conf

# echo '$template GRAYLOGRFC5424,"<%pri%>%protocol-version% %timestamp:::date-rfc3339% %HOSTNAME% %app-name% %procid% %msg%\n"' | tee -a /etc/rsyslog.d/32-graylog2.conf
# echo '$template GRAYLOG2-1,"<%PRI%>1 %timegenerated:::date-rfc3339% %hostname% %syslogtag% - %APP-NAME%: %msg:::drop-last-lf%\n"' | tee /etc/rsyslog.d/32-graylog2.conf

echo '$PreserveFQDN on' | tee -a  /etc/rsyslog.d/32-graylog.conf
echo '*.* @localhost:10514;GRAYLOG' | tee -a  /etc/rsyslog.d/32-graylog.conf


echo "##### Restarting rsyslog #####"
service rsyslog restart

echo "##### Starting web interface #####"
service graylog-web start

#################
echo "Setup Complete!"
echo "You can access Graylog Server by IP $IPADD_ETH0:9000"
echo "User: admin"
echo "Pass: $adminpass"
