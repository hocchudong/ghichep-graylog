## II. Cài đặt Graylog Server trên Centos 7

### 1. Setup mô hình 

![graylog](/images/graylog-install01.png)

Setup Graylog server :

 - OS : Centos 7.3.1611 x 64 bit
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
 
### 1. Cài đặt các gói phụ trợ

```sh
yum install epel-release -y 
yum install pwgen java-1.8.0-openjdk-headless.x86_64 -y
```
### 2. Cài đặt MongoDB
Tạo repo cho MongoDB : 

```sh
vi /etc/yum.repos.d/mongodb-org-3.2.repo
```

Thêm các thông tin vào trong repo

```sh
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc
```

Cài đặt phiên bản mới nhất của MongoDB :

```sh
yum install mongodb-org
```

Khởi động MongoDB và cho phép boot cùng hệ thống :

```sh
chkconfig --add mongod
systemctl daemon-reload
systemctl enable mongod.service
systemctl start mongod.service
```

### 3. Cài đặt Elasticsearch
Cài đặt Elasticsearch GPG key : 

```sh
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
```

 Tạo repo cho Elasticsearch :
 
 ```sh
 [elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=https://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
```

Cài đặt Elasticsearch :

```sh
yum install elasticsearch
```

Sửa tên cluster name thành `graylog` trong file cấu hình : `/etc/elasticsearch/elasticsearch.yml`

Khởi động Elasticsearch và cho phép boot cùng hệ thống : 
```
chkconfig --add elasticsearch
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl restart elasticsearch.service
```
### 4. Cài đặt Graylog
Cài đặt từ file rpm

```
rpm -Uvh https://packages.graylog2.org/repo/packages/graylog-2.1-repository_latest.rpm
yum install graylog-server -y
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

Khởi động Graylog và cho phép boot cùng hệ thống : 

```sh
chkconfig --add graylog-server
systemctl daemon-reload
systemctl enable graylog-server.service
systemctl start graylog-server.service
```

### 5. Chỉnh sửa Selinux
Cho phép Web truy cập network :

```sh
 setsebool -P httpd_can_network_connect 1
```

Nếu như các policy không tuân theo các rule của bạn, có thể add từng port riêng (đã cài đặt `policycoreutils-python`) :

 - Graylog REST API và  web interface: `semanage port -a -t http_port_t -p tcp 9000`
 - Elasticsearch (chỉ cho phếp HTTP API được dùng):  `semanage port -a -t http_port_t -p tcp 9200`
 - Cho phép MongoDB sử dụng port (27017/tcp):  `semanage port -a -t mongod_port_t -p tcp 27017`
 
Đăng nhập Graylog-Web với địa chỉ : `http://IP:9000`
 
![graylog](/images/graylog-install02.png)