#!/bin/bash
#############################################################
# Modify from https://github.com/mrlesmithjr/graylog2
# Thanks you: Larry Smith Jr. / TW. @mrlesmithjr
# Graylog V1.0
# Ubuntu 14.04.1
# Update: 03/03/2015
# Author: Congto / TW: @tothanhcong
#############################################################

# Get IP Server
IPADDY="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"

echo "##### Script install Graylog V1.0 (Script cai dat Graylog V1.0) ######"
sleep 3
echo "##### Enter password for Graylog server (Nhap password cho Graylog) #####"
read adminpass

#update
apt-get update

#install software
apt-get -y install git curl build-essential openjdk-7-jre pwgen wget ssh ntp

wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.4.deb

#install elasticsearch

dpkg -i elasticsearch-1.4.4.deb
sed -i -e 's|#cluster.name: elasticsearch|cluster.name: graylog2|' /etc/elasticsearch/elasticsearch.yml

echo "#### Restart elasticsearch ####"
sleep 3
service elasticsearch restart

#setup file limits for ES
mv /etc/security/limits.conf /etc/security/limits.bak
grep -Ev "# End of file" /etc/security/limits.bak > /etc/security/limits.conf
echo "elasticsearch soft nofile 32000" >> /etc/security/limits.conf
echo "elasticsearch hard nofile 32000" >> /etc/security/limits.conf
echo "# End of file" >> /etc/security/limits.conf

#Install Mongodb
apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

apt-get update

apt-get install -y mongodb-org

#Start mongodb
service mongod start

#Test connection
while ! nc -vz localhost 27017; do sleep 1; done

echo "##### Install sussces MONGODB #####"
sleep 3

#Download Graylog2 tarballs

echo "##### Install Graylog1.0 #####"
wget https://packages.graylog2.org/repo/packages/graylog-1.0-repository-ubuntu14.04_latest.deb
dpkg -i graylog-1.0-repository-ubuntu14.04_latest.deb
apt-get install apt-transport-https
apt-get update
apt-get install graylog-server graylog-web

pass_secret=$(pwgen -s 96)
sed -i -e 's|password_secret =|password_secret = '$pass_secret'|' /etc/graylog/server/server.conf

admin_hash=$(echo -n $adminpass |sha256sum|awk '{print $1}')
sed -i -e "s|root_password_sha2 =|root_password_sha2 = $admin_hash|" /etc/graylog/server/server.conf
sed -i -e 's|elasticsearch_shards = 4|elasticsearch_shards = 1|' /etc/graylog/server/server.conf
sed -i -e 's|mongodb_useauth = true|mongodb_useauth = false|' /etc/graylog/server/server.conf
sed -i -e 's|#elasticsearch_discovery_zen_ping_multicast_enabled = false|elasticsearch_discovery_zen_ping_multicast_enabled = false|' /etc/graylog/server/server.conf
sed -i -e 's|#elasticsearch_discovery_zen_ping_unicast_hosts = 192.168.1.203:9300|elasticsearch_discovery_zen_ping_unicast_hosts = 127.0.0.1:9300|' /etc/graylog/server/server.conf

sed -i 's|retention_strategy = delete|retention_strategy = close|' /etc/graylog/server/server.conf

sed -i -e 's|#rest_transport_uri = http://192.168.1.1:12900/|rest_transport_uri = http://127.0.0.1:12900/|' /etc/graylog/server/server.conf


service graylog-server start

echo "Waiting for Graylog server to start!"
# while ! nc -vz localhost 12900; do sleep 1; done

echo "##### Configuring Graylog Web interface #####"
sleep 3
sed -i -e 's|graylog2-server.uris=""|graylog2-server.uris="http://127.0.0.1:12900/"|' /etc/graylog/web/web.conf
app_secret=$(pwgen -s 96)
sed -i -e 's|application.secret=""|application.secret="'$app_secret'"|' /etc/graylog/web/web.conf
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
echo "You can access Graylog Server by IP $IPADDY:9000"
echo "User: admin"
echo "Pass: $adminpass"
