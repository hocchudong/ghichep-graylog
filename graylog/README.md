# Script install GRAYLOG V.10

### INFO
```sh
# Graylog V1.0
# Elasticsearch 1.4.4
# MongoDB 2.6.8
# Ubuntu 14.04.1
# Update: 03/03/2015
```

#### DIAGRAM LAB
![Topo LAB](grayloglab.png)

#### GUIDE
- Graylog on Server 
```sh
wget https://raw.githubusercontent.com/hocchudong/log-script/master/graylog/graylog-server.sh
bash graylog-server.sh

```

- Graylog for client 1 (Ubuntu)
```sh
wget https://raw.githubusercontent.com/hocchudong/log-script/master/graylog/graylog-client-ubuntu.sh
bash graylog-client-ubuntu.sh
```


