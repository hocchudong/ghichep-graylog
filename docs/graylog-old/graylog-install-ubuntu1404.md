## I. Cài đặt Graylog Server trên Ubuntu 14.04 x 64 bit

### 1. Setup mô hình 

![graylog](/images/graylog-install01.png)

Setup Graylog server :

 - OS : Ubuntu 14.04 x 64 bit
 - IP : 172.16.69.60
	
Thông số phần cứng : 

 - RAM : 4GB
 - HDD : 100GB
 - CPU : 4 Core
	
### 2. Phiên bản các thành phần

 - Graylog : version 2.2 
 - Elasticsearch : > 2.x
 - MongoDB : > 2.4
 - Java : > OpenJDK 8
 
## II. Cài đặt Graylog

### 1. Cài đặt các package phụ trợ
```sh
add-apt-repository ppa:openjdk-r/ppa
apt-get update -y 
apt-get install -y apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen
```
### 2. Cài đặt MongoDB
```sh
apt-get install -y mongodb-server
```
### 3. Cài đặt Elasticsearch
Graylog 2.0.0 yêu cầu Elasticsearch 2.x trở lên.

```sh
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://packages.elastic.co/elasticsearch/2.x/debian stable main" | tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
apt-get update && sudo apt-get install elasticsearch
```
Chỉnh sửa file ``/etc/elasticsearch/elasticsearch.yml`` và sửa cluster name thành `graylog`

Sau khi cài đặt xong :
```sh
update-rc.d elasticsearch defaults
service elasticsearch restart

```
### 4. Cài đặt Graylog

```sh
wget http://packages.graylog2.org/repo/packages/graylog-2.2-repository_latest.deb
dpkg -i graylog-2.2-repository_latest.deb
apt-get update && apt-get -y install graylog-server
```
Khai báo 2 thông số `IPADD` bằng IP của máy Graylog và `adminpass` với password đăng nhập Graylog Web muốn đặt.

```sh
echo -e "\033[32m  ##### Enter IP for Graylog server (Nhap IP cho Graylog) ##### \033[0m"
read -r IPADD
sleep 3
echo -e "\033[32m  ##### Enter password for Graylog server (Nhap password cho Graylog) ##### \033[0m"
read -r adminpass
```

Chỉnh sửa cấu hình của Graylog trong file `/etc/graylog/server/server.conf`

```
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
```

Restart Graylog :
```sh
rm -f /etc/init/graylog-server.override
start graylog-server
```

Đăng nhập Graylog-Web với địa chỉ : `http://IP:9000`
 
![graylog](/images/graylog-install02.png)
