#!/bin/bash

echo "#### SAO LUU FILE CAU HINH APACHE.CONF VA 000-DEFAULT.CONF ####"

apache2=/etc/apache2/apache2.conf
default=/etc/apache2/sites-enabled/000-default.conf

test -f $apache2.bka || cp $apache2 $apache2.bka
test -f $default.bka || cp $default $default.bka
#mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bka
#mv /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf.bka

sleep 3

echo "#### BAT DAU CAU HINH ####"

sed -i 's/ErrorLog ${APACHE_LOG_DIR}\/error.log/ErrorLog syslog:local1/g' /etc/apache2/apache2.conf
sed -i 's/ErrorLog ${APACHE_LOG_DIR}\/error.log/ErrorLog syslog:local1/g' /etc/apache2/sites-enabled/000-default.conf
sed -i 's/CustomLog ${APACHE_LOG_DIR}\/access.log combined/CustomLog "| \/usr\/bin\/logger -taccess -plocal1.info" combined/g' /etc/apache2/sites-enabled/000-default.conf

sleep 3

echo "#### KHOI DONG LAI DICH VU ####"
service rsyslog restart
service apache2 restart

sleep 3
