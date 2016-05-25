### Ghi chép hướng dẫn cài đặt graylog 2.x

### INFO
```sh
# Graylog V2.0.1
# Elasticsearch 2.
# MongoDB 
# Ubuntu 14.04.2
# Update: 25/5/2016
```

#### DIAGRAM LAB
*** 
![Topo LAB](images/grayloglab.png)

####Cách cài đặt

 - Với Graylog Server
 
 ```sh
 wget https://raw.githubusercontent.com/hocchudong/ghichep-graylog/master/graylog/graylog-scripts/graylog2-0.sh
 ```
 - Với Client
 ```sh
 wget https://raw.githubusercontent.com/hocchudong/ghichep-graylog/master/graylog/graylog-scripts/graylog-collector.sh
 ```
 
 #####Một số *lưu ý* khi chạy script:
 
 - Nhập password cho admin khi đăng nhập vào Web-interface
 ![NOTE1](images/1.png)

 - Ấn phím *ENTER* để tiếp tục
 ![NOTE2](images/2.png)

 - Sau khi Reboot lại máy, khởi động Graylog và restart rsyslog
 ![NOTE3](images/3.png)

 - Tạo các Input cơ bản để nhận dữ liệu từ Client và từ chính Graylog-server
 ![NOTE4](images/4.png)
 ![NOTE5](images/5.png)
 ![NOTE6](images/6.png)
 
####Các tham khảo
  - Sử dụng Web-Interface: 
```sh
https://github.com/hocchudong/ghichep-graylog/blob/master/graylog/graylog-web%20interface/Graylog-Interface.md)
```
  - Cấu hình cho Graylog Collector:
```sh
https://github.com/hocchudong/ghichep-graylog/tree/master/graylog/graylog-collector
```
