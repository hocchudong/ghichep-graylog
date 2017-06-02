echo -e "\033[32m ####Bat dau cai dat Graylog Collector-Sidecar#### \033[0m"
wget https://github.com/Graylog2/collector-sidecar/releases/download/0.1.1/collector-sidecar-0.1.1-1.x86_64.rpm
rpm -i collector-sidecar-0.1.1-1.x86_64.rpm

sleep 3

echo -e "\033[32m ##### Nhap IP cua Graylog Server##### \033[0m"
read -r graylogip
sed -i '6i\    - /var/log/ \' /etc/graylog/collector-sidecar/collector_sidecar.yml
sed -i "s|server_url: http:\/\/127.0.0.1:9000\/api\/|server_url: http:\/\/$graylogip:9000\/api\/|g" /etc/graylog/collector-sidecar/collector_sidecar.yml
sed -i "s|node_id: graylog-collector-sidecar|node_id: $HOSTNAME|g" /etc/graylog/collector-sidecar/collector_sidecar.yml
#sed -i "s|    - linux|#    - linux|g" /etc/graylog/collector-sidecar/collector_sidecar.yml
#sed -i "s|    - apache|#    - apache|g" /etc/graylog/collector-sidecar/collector_sidecar.yml
sed -i '15i\    - mdt-all\' /etc/graylog/collector-sidecar/collector_sidecar.yml

graylog-collector-sidecar -service install
service collector-sidecar start

echo -e "\033[32m ##### Da cai dat xong Graylog Collector-sidecar ##### \033[0m"