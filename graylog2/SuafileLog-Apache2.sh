#!bin/bash

#### Sua file cau hinh Log cua apache2 bang cach kiem tra su ton tai cua file ####

echo " Start restore!!!!!!"
file1="/etc/apache2/sites-enabled/000-default"
file2="/etc/apache2/sites-enabled/000-default.conf"

if [ -f $file1 ]
then

echo "#### SAO LUU FILE CAU HINH APACHE.CONF VA 000-DEFAULT.CONF ####"

apache2=/etc/apache2/apache2.conf
default=/etc/apache2/sites-enabled/000-default

test -f $apache2.bka || cp $apache2 $apache2.bka
test -f $default.bka || cp $default $default.bka

sleep 3

echo "#### BAT DAU CAU HINH ####"

sed -i 's/ErrorLog ${APACHE_LOG_DIR}\/error.log/ErrorLog syslog:local1/g' /etc/apache2/apache2.conf
sed -i 's/ErrorLog ${APACHE_LOG_DIR}\/error.log/ErrorLog syslog:local1/g' /etc/apache2/sites-enabled/000-default
sed -i 's/CustomLog ${APACHE_LOG_DIR}\/access.log combined/CustomLog "| \/usr\/bin\/logger -t apache -p local1.info" combined/g' /etc/apache2/sites-enabled/000-default

sleep 3

echo "#### KHOI DONG LAI DICH VU ####"
service rsyslog restart
service apache2 restart

sleep 3

fi

if [ -f $file2 ]

then

echo "#### SAO LUU FILE CAU HINH APACHE.CONF VA 000-DEFAULT.CONF ####"

apache2=/etc/apache2/apache2.conf
default=/etc/apache2/sites-enabled/000-default.conf

test -f $apache2.bka || cp $apache2 $apache2.bka
test -f $default.bka || cp $default $default.bka

sleep 3

echo "#### BAT DAU CAU HINH ####"

sed -i 's/ErrorLog ${APACHE_LOG_DIR}\/error.log/ErrorLog syslog:local1/g' /etc/apache2/apache2.conf
sed -i 's/ErrorLog ${APACHE_LOG_DIR}\/error.log/ErrorLog syslog:local1/g' /etc/apache2/sites-enabled/000-default.conf
sed -i 's/CustomLog ${APACHE_LOG_DIR}\/access.log combined/CustomLog "| \/usr\/bin\/logger -t apache -p local1.info" combined/g' /etc/apache2/sites-enabled/000-default.conf

sleep 3

echo "#### KHOI DONG LAI DICH VU ####"
service rsyslog restart
service apache2 restart

sleep 3

fi
echo " Finish!!!!!!!"

