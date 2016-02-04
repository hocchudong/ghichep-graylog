#!/bin/bash

#update
apt-get -qq update

#install software
apt-get -y install git curl build-essential openjdk-7-jre pwgen wget ssh ntp

#install Desktop environment
# apt-get -y install gnome-desktop-environment

#download files

cd /opt
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.2.deb

#install elasticsearch

dpkg -i elasticsearch-1.4.2.deb
sed -i -e 's|#cluster.name: elasticsearch|cluster.name: graylog2|' /etc/elasticsearch/elasticsearch.yml

#set up elasticsearch with defaults

update-rc.d elasticsearch defaults

#Restart elasticsearch

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

apt-get -qq update

apt-get install -y mongodb-org

#Start mongodb

service mongod start

#Test connection

while ! nc -vz localhost 27017; do sleep 1; done

#Download Graylog2 tarballs

echo "Downloading Files"

wget http://packages.graylog2.org/releases/graylog2-server/graylog2-server-0.92.4.tgz
wget http://packages.graylog2.org/releases/graylog2-web-interface/graylog2-web-interface-0.92.4.tgz

#Extract 

echo "Extracting files"

for i in *.*gz
do
tar zxf "$i"
done

#Create links

echo "Creating symbolic links"

ln -s graylog2-server-0.9*/ graylog2-server
ln -s graylog2-web-interface-0.9*/ graylog2-web-interface

#Install graylog2 server

echo "Installing Graylog2 server"
#echo -n "Enter password for web interface admin account:  "
#read password

cd graylog2-server/
cp /opt/graylog2-server/graylog2.conf.example /etc/graylog2.conf
pass_secret=$(pwgen -s 96)
sed -i -e 's|password_secret =|password_secret = '$pass_secret'|' /etc/graylog2.conf

admin_hash=$(echo -n 'PTCC@!2o015'|sha256sum|awk '{print $1}')
sed -i -e "s|root_password_sha2 =|root_password_sha2 = $admin_hash|" /etc/graylog2.conf
sed -i -e 's|elasticsearch_shards = 4|elasticsearch_shards = 1|' /etc/graylog2.conf
sed -i -e 's|mongodb_useauth = true|mongodb_useauth = false|' /etc/graylog2.conf
sed -i -e 's|#elasticsearch_discovery_zen_ping_multicast_enabled = false|elasticsearch_discovery_zen_ping_multicast_enabled = false|' /etc/graylog2.conf
sed -i -e 's|#elasticsearch_discovery_zen_ping_unicast_hosts = 192.168.1.203:9300|elasticsearch_discovery_zen_ping_unicast_hosts = 127.0.0.1:9300|' /etc/graylog2.conf

sed -i 's|retention_strategy = delete|retention_strategy = close|' /etc/graylog2.conf

sed -i -e 's|#rest_transport_uri = http://192.168.1.1:12900/|rest_transport_uri = http://127.0.0.1:12900/|' /etc/graylog2.conf


#Credits for startup script to mrlesmithjr
# Create graylog2-server startup script
echo "Creating /etc/init.d/graylog2-server startup script"
(
cat <<'EOF'
#!/bin/bash
### BEGIN INIT INFO
# Provides:          graylog2-server
# Required-Start:    $elasticsearch
# Required-Stop:     $graylog2-web-interface
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start graylog2-server at boot time
# Description:       Starts graylog2-server using start-stop-daemon
### END INIT INFO
CMD=$1
NOHUP=`which nohup`
GRAYLOG2CTL_DIR="/opt/graylog2-server/bin"
GRAYLOG2_SERVER_JAR=graylog2-server.jar
GRAYLOG2_CONF=/etc/graylog2.conf
GRAYLOG2_PID=/tmp/graylog2.pid
LOG_FILE=log/graylog2-server.log
start() {
    echo "Starting graylog2-server ..."
    cd "$GRAYLOG2CTL_DIR/.."
#    sleep 2m
    $NOHUP java -jar ${GRAYLOG2_SERVER_JAR} -f ${GRAYLOG2_CONF} -p ${GRAYLOG2_PID} >> ${LOG_FILE} &
}
stop() {
    PID=`cat ${GRAYLOG2_PID}`
    echo "Stopping graylog2-server ($PID) ..."
    if kill $PID; then
        rm ${GRAYLOG2_PID}
    fi
}
restart() {
    echo "Restarting graylog2-server ..."
    stop
    start
}
status() {
    pid=$(get_pid)
    if [ ! -z $pid ]; then
        if pid_running $pid; then
            echo "graylog2-server running as pid $pid"
            return 0
        else
            echo "Stale pid file with $pid - removing..."
            rm ${GRAYLOG2_PID}
        fi
    fi
    echo "graylog2-server not running"
}
get_pid() {
    cat ${GRAYLOG2_PID} 2> /dev/null
}
pid_running() {
    kill -0 $1 2> /dev/null
}
case "$CMD" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    *)
        echo "Usage $0 {start|stop|restart|status}"
        RETVAL=1
esac
EOF
) | tee /etc/init.d/graylog2-server


chmod +x /etc/init.d/graylog2-server

update-rc.d graylog2-server defaults

echo "starting graylog2 server"

service graylog2-server start

echo "Waiting for Graylog2-Server to start!"
while ! nc -vz localhost 12900; do sleep 1; done

#Install web interface

echo "Installing web interface"


#credits for script to mrlesmithjr

echo "Creating Graylog2-web-interface startup script"
(
cat <<'EOF'
#!/bin/sh
### BEGIN INIT INFO
# Provides:          graylog2-web-interface
# Required-Start:    $graylog2-server
# Required-Stop:     $graylog2-server
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start graylog2-server at boot time
# Description:       Starts graylog2-server using start-stop-daemon
### END INIT INFO
CMD=$1
NOHUP=`which nohup`
JAVA_CMD=/usr/bin/java
GRAYLOG2_WEB_INTERFACE_HOME=/opt/graylog2-web-interface
GRAYLOG2_WEB_INTERFACE_PID=/opt/graylog2-web-interface/RUNNING_PID
start() {
echo "Starting graylog2-web-interface ..."
#sleep 3m
$NOHUP /opt/graylog2-web-interface/bin/graylog2-web-interface &
}
stop() {
echo "Stopping graylog2-web-interface ($PID) ..."
PID=`cat ${GRAYLOG2_WEB_INTERFACE_PID}`
if kill $PID; then
        rm ${GRAYLOG2_WEB_INTERFACE_PID}
fi
}
restart() {
echo "Restarting graylog2-web-interface ..."
stop
start
}
status() {
    pid=$(get_pid)
    if [ ! -z $pid ]; then
        if pid_running $pid; then
            echo "graylog2-web-interface running as pid $pid"
            return 0
        else
            echo "Stale pid file with $pid - removing..."
            rm ${GRAYLOG2_WEB_INTERFACE_PID}
        fi
    fi
    echo "graylog2-web-interface not running"
}
get_pid() {
    cat ${GRAYLOG2_WEB_INTERFACE_PID} 2> /dev/null
}
pid_running() {
    kill -0 $1 2> /dev/null
}
case "$CMD" in
        start)
                start
                ;;
        stop)
                stop
                ;;
        restart)
                restart
                ;;
        status)
                status
                ;;
*)
echo "Usage $0 {start|stop|restart|status}"
RETVAL=1
esac
EOF
) | tee /etc/init.d/graylog2-web


chmod +x /etc/init.d/graylog2-web

#Set webserver to defaults

update-rc.d graylog2-web defaults


echo "configuring rsyslog and web interface"

sed -i -e 's|#$ModLoad imudp|$ModLoad imudp|' /etc/rsyslog.conf
sed -i -e 's|#$UDPServerRun 514|$UDPServerRun 514|' /etc/rsyslog.conf
sed -i -e 's|#$ModLoad imtcp|$ModLoad imtcp|' /etc/rsyslog.conf
sed -i -e 's|#$InputTCPServerRun 514|$InputTCPServerRun 514|' /etc/rsyslog.conf
sed -i -e 's|*.*;auth,authpriv.none|#*.*;auth,authpriv.none|' /etc/rsyslog.d/50-default.conf
echo '$template GRAYLOG2-1,"<%PRI%>1 %timegenerated:::date-rfc3339% %hostname% %syslogtag% - %APP-NAME%: %msg:::drop-last-lf%\n"' | tee /etc/rsyslog.d/32-graylog2.conf
echo '$template GRAYLOG2-2,"<%pri%>1 %timegenerated:::date-rfc3339% %fromhost% %app-name% %procid% %msg%\n"'  | tee -a /etc/rsyslog.d/32-graylog2.conf
echo '$template GRAYLOGRFC5424,"<%pri%>%protocol-version% %timestamp:::date-rfc3339% %HOSTNAME% %app-name% %procid% %msg%\n"' | tee -a /etc/rsyslog.d/32-graylog2.conf
echo '$PreserveFQDN on' | tee -a  /etc/rsyslog.d/32-graylog2.conf
echo '*.* @localhost:10514;GRAYLOG2-2' | tee -a  /etc/rsyslog.d/32-graylog2.conf
sed -i -e 's|graylog2-server.uris=""|graylog2-server.uris="http://127.0.0.1:12900/"|' /opt/graylog2-web-interface/conf/graylog2-web-interface.conf
app_secret=$(pwgen -s 96)
sed -i -e 's|application.secret=""|application.secret="'$app_secret'"|' /opt/graylog2-web-interface/conf/graylog2-web-interface.conf

echo "Setting permissions"

chown -R root:root /opt/graylog2*

echo "restarting rsyslog"

service rsyslog restart

echo "starting web interface"

service graylog2-web start

echo "Setup Complete!"


