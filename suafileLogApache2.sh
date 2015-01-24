#!/bin/bash

#### Sua file cau hinh Log cua apache2 bang cach kiem tra he dieu hanh #####

echo "#### START ####"
a=`lsb_release -a | awk '/Release/{print $2}'`
duongdanfile2=/etc/apache2/apache2.conf
echo $a
if [ "$a" = "12.04" ];then
echo "### HE DIEU HANH BAN DUNG LA U12.04 ###"
duongdanfile1=/etc/apache2/sites-enabled/000-default

fi
if [ "$a" = "14.04" ];then
echo "### HE DIEU HANH BAN DUNG LA U14.04 ###"
duongdanfile1=/etc/apache2/sites-enabled/000-default.conf

fi

test -f $duongdanfile2.bka || cp $duongdanfile2 $duongdanfile2.bka
test -f $duongdanfile1.bka || cp $duongdanfile1 $duongdanfile1.bka

sleep 3

echo "#### BAT DAU CAU HINH ####"

sed -i 's/ErrorLog ${APACHE_LOG_DIR}\/error.log/ErrorLog syslog:local1/g' /etc/apache2/apache2.conf
sed -i 's/ErrorLog ${APACHE_LOG_DIR}\/error.log/ErrorLog syslog:local1/g' $duongdanfile1
sed -i 's/CustomLog ${APACHE_LOG_DIR}\/access.log combined/CustomLog "| \/usr\/bin\/logger -t apache -p local1.info" combined/g' $duongdanfile1

sleep 3

echo "#### KHOI DONG LAI DICH VU ####"
service rsyslog restart
service apache2 restart

sleep 3
