## I. Cài đặt trên Ubuntu
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
wget https://packages.graylog2.org/repo/packages/graylog-2.1-repository_latest.deb
dpkg -i graylog-2.1-repository_latest.deb
apt-get update && sudo apt-get install graylog-server
```
Thêm `password_secret` và `root_password_sha2`. Dùng câu lệnh sau để tạo `root_password_sha2` :
```sh
echo -n yourpassword | sha256sum
```
Để kết nối tới Graylog, cần đặt `rest_listen_uri` và `web_listen_uri` với hostname hoặc public IP của máy

Restart Graylog :
```sh
rm -f /etc/init/graylog-server.override
start graylog-server
```

## II. Cài đặt trên Centos 7
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
Thêm `password_secret` và `root_password_sha2`. Dùng câu lệnh sau để tạo `root_password_sha2` :
```sh
echo -n yourpassword | sha256sum
```
Để kết nối tới Graylog, cần đặt `rest_listen_uri` và `web_listen_uri` với hostname hoặc public IP của máy.

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
