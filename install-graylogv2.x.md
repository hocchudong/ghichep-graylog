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
sed -i -e 's|#cluster.name: elasticsearch|cluster.name: graylog|' /etc/elasticsearch/elasticsearch.yml
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
sudo apt-get install openjdk-8-jre
```


#### Graylog 2.x

```sh

wget https://packages.graylog2.org/releases/graylog/graylog-2.0.0-alpha.1.tgz
tar xvfz graylog-2.0.0-alpha.1.tgz
cd 
```