### Ghi chép hướng dẫn cài đặt graylog 2.x

#### Cài đặt Elasticsearch 2.x

```sh
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list

apt-get -y  update
apt-get -y install elasticsearch
```

- Cấu hình cho Elasticsearch
```sh
sed -i -e 's|#cluster.name: my-application|cluster.name: graylog|' /etc/elasticsearch/elasticsearch.yml
sed -i -e 's|#http.port: 9200|http.port: 9200|' /etc/elasticsearch/elasticsearch.yml

## Thay dia chi IP cua may chu vao bien IPADD
sed -i -e 's|#discovery.zen.ping.unicast.hosts: \["host1", "host2:port"\]|discovery.zen.ping.unicast.hosts: ['\"IPADD:9300\"']|' /etc/elasticsearch/elasticsearch.yml
```

-  Khởi động lại Elasticsearch
```sh
service elasticsearch restart
update-rc.d elasticsearch defaults
```



#### For MongoDB

```sh
apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

apt-get -y  update
apt-get -y install mongodb-org

service mongod start

# Kiểm tra kết nối cho MongoDB
while ! nc -vz localhost 27017; do sleep 1; done

echo -e "Install sussces MONGODB"

```

#### JAVA 
```sh
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install openjdk-8-jdk
Sửa JAVA_HOME
/etc/environment
	JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
Chạy biến : 
source /etc/environment
```


#### Graylog 2.x

```sh

wget https://packages.graylog2.org/releases/graylog/graylog-2.0.0-alpha.1.tgz
tar xvfz graylog-2.0.0-alpha.1.tgz
cd graylog-2.0.0-alpha.5/
 - Tạo thư mục cho config cho Graylog
mkdir /etc/graylog/
mkdir /etc/graylog/server/
cp graylog.conf.example /etc/graylog/server/server.conf
 - Cấu hình cho Graylog Server
 Tạo password_secret và password cho admin
 pwgen -N 1 -s 96
 echo -n yourpassword | shasum -a 256
 <img src="http://i.imgur.com/wvBoSso.png">
## Thay password_secret va admin's password voi cac gia tri tuong ung duoc tao ra
## Thay dia chi IP cua may chu vao bien IPADD
sed -i -e 's|password_secret =|password_secret = *password_secret*|' /etc/graylog/server/server.conf
sed -i -e 's|root_password_sha2 =|root_password_sha2 = *admin's password*|' /etc/graylog/server/server.conf
sed -i -e 's|#root_timezone = UTC|root_timezone = Asia/Ho_Chi_Minh|' /etc/graylog/server/server.conf
sed -i -e 's|rest_listen_uri = http://127.0.0.1:12900/|rest_listen_uri = http://0.0.0.0:12900/|' /etc/graylog/server/server.conf
sed -i -e 's|#web_listen_uri = http://127.0.0.1:9000/|web_listen_uri = http://IPADD:9000/|' /etc/graylog/server/server.conf
sed -i -e 's|retention_strategy = delete|retention_strategy = close|' /etc/graylog/server/server.conf
sed -i -e 's|elasticsearch_shards = 4|elasticsearch_shards = 1|' /etc/graylog/server/server.conf
sed -i -e 's|#elasticsearch_discovery_zen_ping_multicast_enabled = false|elasticsearch_discovery_zen_ping_multicast_enabled = false|' /etc/graylog/server/server.conf
sed -i -e 's|#elasticsearch_discovery_zen_ping_unicast_hosts = 127.0.0.1:9300|elasticsearch_discovery_zen_ping_unicast_hosts = IPADD:9300|' /etc/graylog/server/server.conf
Khởi động dịch vụ :
cd graylog-2.0.0-alpha.5/bin/
./graylogctl start
