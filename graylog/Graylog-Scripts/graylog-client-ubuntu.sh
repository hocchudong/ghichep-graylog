#!/bin/bash

#update
echo "##### ENTER IP ADDRESS GRAYLOG SERVER (NHAP IP CUA GRAYLOG SERVER) #####"
read -r IP_GRAYLOG

apt-get update
# SAO LUU FILE /etc/rsyslog.d/50-default.conf
cp /etc/rsyslog.d/50-default.conf /etc/rsyslog.d/50-default.conf.bka

sed -i -e 's|*.*;auth,authpriv.none|#*.*;auth,authpriv.none|' /etc/rsyslog.d/50-default.conf
# echo '$template GRAYLOG2-1,"<%PRI%>1 %timegenerated:::date-rfc3339% %hostname% %syslogtag% - %APP-NAME%: %msg:::drop-last-lf%\n"' >> /etc/rsyslog.d/50-default.conf

echo '$template GRAYLOG,"<%pri%>1 %timegenerated:::date-rfc3339% %fromhost% %app-name% %procid% %msg%\n"'  >> /etc/rsyslog.d/50-default.conf

echo '$template GRAYLOGRFC5424,"<%pri%>%protocol-version% %timestamp:::date-rfc3339% %HOSTNAME% %app-name% %procid% %msg%\n"' >>  /etc/rsyslog.d/50-default.conf
echo '$PreserveFQDN on' >> /etc/rsyslog.d/50-default.conf
echo "*.* @$IP_GRAYLOG:10514;GRAYLOG" >>  /etc/rsyslog.d/50-default.conf

# chown -R syslog:syslog /var/log

echo "Restarting rsyslog"
service rsyslog restart

echo "##### COMPLETE SYSLOG FOR CLIENT (HOAN THANH CAU HINH RSYSLOG CHO CLIENT) #####"


