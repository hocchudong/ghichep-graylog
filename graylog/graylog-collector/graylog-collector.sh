#!/bin/bash
#############################################################
# Graylog-Collector V0.4.1
# Ubuntu 14.04.02
# Update 5/1/2015
# Author: manhdinh 
#############################################################
echo -e "\033[33m  ##### Script install Graylog-Collector V0.4.1 (Script cai dat Graylog-Collector V0.4.1) ###### \033[0m"
sleep 3
echo -e "\033[33m  ##### Update and install Java 7 (Update va cai dat Java 7) ###### \033[0m"
sleep 3
apt-get update
apt-get install openjdk-7-jdk -y
sudo wget https://packages.graylog2.org/repo/packages/graylog-collector-latest-repository-ubuntu14.04_latest.deb
sudo dpkg -i graylog-collector-latest-repository-ubuntu14.04_latest.deb
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install graylog-collector -y
#Add JAVA_HOME Parameter
echo 'JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"' >> /etc/enviroment
source /etc/environment 
#Privilege for Graylog-collector
gpasswd -a graylog-collector adm
gpasswd -a graylog-collector root
echo -e "\033[33m  ##### Config Input and Output for Graylog-Collector in directory /etc/graylog/collector/collector.conf ###### \033[0m"
sleep 3
cp /etc/graylog/collector/collector.conf /etc/graylog/collector/collector.conf.bak
