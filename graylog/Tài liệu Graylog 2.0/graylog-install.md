##I. Cài đặt trên Ubuntu
###1. Cài đặt các package phụ trợ
```sh
apt-get install apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen
```
###2. Cài đặt MongoDB
```sh
apt-get install mongodb-server
```
###3. Cài đặt Elasticsearch
Graylog 2.0.0 yêu cầu Elasticsearch 2.x trở lên.
```sh
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
sudo apt-get update && sudo apt-get install elasticsearch
```
Chỉnh sửa file ``/etc/elasticsearch/elasticsearch.yml`` và sửa cluster name thành `graylog`

Sau khi cài đặt xong :
```sh
/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service
/bin/systemctl restart elasticsearch.service
```
###4. Cài đặt Graylog
```sh
wget https://packages.graylog2.org/repo/packages/graylog-2.1-repository_latest.deb
dpkg -i graylog-2.1-repository_latest.deb
apt-get update && sudo apt-get install graylog-server
```
Thêm `password_secret` và `root_password_sha2`. Dùng câu lệnh sau để tạo `root_password_sha2` :
```sh
echo -n yourpassword | sha256sum
```
Để kết nối tới 