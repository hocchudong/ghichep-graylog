## Các bước cài đặt Collector Sidecar


## Cài đặt Nxlog

- Cài các gói cần thiết (yêu cầu tải đúng phiên bản)

```sh
apt-get install -f libapr1 libc6 libcap2 libdbi1 libexpat1 libpcre3 libperl5.18 libssl1.0.0 zlib1g adduser openssl lsb-base

```

- Cài đặt nxlog

```sh
wget https://nxlog.co/system/files/products/files/1/nxlog-ce_2.9.1716_ubuntu_1404_amd64.deb
dpkg -i nxlog-ce_2.9.1716_ubuntu_1404_amd64.deb
```

- Disable nxlog 

```sh 
sudo /etc/init.d/nxlog stop
sudo update-rc.d -f nxlog remove
sudo gpasswd -a nxlog adm
```

## Cài đặt collector-sidecar

###  Tải collector-sidecar

```sh
wget https://github.com/Graylog2/collector-sidecar/releases/download/0.0.9-beta.2/collector-sidecar_0.0.9-1_amd64.deb
sudo dpkg -i collector-sidecar_0.0.9-1_amd64.deb
```

###  Khởi động dịch vụ collector-sidecar

```sh
sudo graylog-collector-sidecar -service install
sudo service collector-sidecar start
```

### Cấu hình collector-sidecar

```sh
server_url: http://IP_ADD_Graylog_server:12900
update_interval: 10
tls_skip_verify: false
send_status: true
list_log_files:
node_id: graylog-collector-sidecar
collector_id: file:/etc/graylog/collector-sidecar/collector-id
log_path: /var/log/graylog/collector-sidecar
log_rotation_time: 86400
log_max_age: 604800
tags:
    - linux
    - apache
backends:
    - name: nxlog
      enabled: false
      binary_path: /usr/bin/nxlog
      configuration_path: /etc/graylog/collector-sidecar/generated/nxlog.conf
    - name: filebeat
      enabled: true
      binary_path: /usr/bin/filebeat
      configuration_path: /etc/graylog/collector-sidecar/generated/filebeat.yml
```

-

