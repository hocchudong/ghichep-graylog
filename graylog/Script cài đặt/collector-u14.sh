#!/bin/bash
#############################################################
# Collector cho client
# Ubuntu 14.04.1
# Update: 30/12/2015
# Author: Congto / @tothanhcong
#############################################################
#############################################################

# Cai dat java
apt-get update
apt-get install openjdk-7-jdk -y	

# Cai dat collector
wget https://packages.graylog2.org/repo/packages/graylog-collector-latest-repository-ubuntu14.04_latest.deb
sudo dpkg -i graylog-collector-latest-repository-ubuntu14.04_latest.deb
sudo apt-get install apt-transport-https
sudo apt-get update		
sudo apt-get install graylog-collector -y

