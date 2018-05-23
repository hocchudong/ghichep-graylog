## Hướng dẫn cài đặt Graylog bằng script

## I. Chuẩn bị

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
	
## II. Cài đặt 

### 1. Cài đặt trên Graylog server

 - Dowload và chạy script
 
```sh
wget https://raw.githubusercontent.com/hocchudong/ghichep-graylog/master/scripts/graylog2-0.sh
bash graylog2-0.sh
```
**Chú ý** Khi được hỏi hãy nhập 2 thông số `IPADD` bằng IP của máy Graylog và `adminpass` với password đăng nhập Graylog Web muốn đặt.

 - Đăng nhập Graylog-Web với địa chỉ : `http://IP:9000`
 
![graylog](/images/graylog-install02.png)
 
  - Setup các input để nhận log từ client
 
**Step 1**
Tạo **Beat input** để collector có thể gửi data đến. Click vào `System -> Input` và khởi động một global Beat input với địa chỉ là 0.0.0.0 và port 5044.

![graylog](/images/step1.png)

**Step 2**

Chuyển qua cấu hình collector. Trên Graylog Webinterface click vào : System -> Collectors -> Manage configurations

![graylog](/images/step2.png)

**Step 3**

Tạo một cấu hình mới

![graylog](/images/step3-1.png)

**Step 4**

Thêm tên cho cấu hình

![graylog](/images/step3-2.png)

**Step 5**

Click vào cấu hình mới và tạo Filebeat output.

![graylog](/images/step4.png)

**Step 6**

Tạo Filebeat file input để thu thập Apache log

![graylog](/images/step5.png)

**Step 7**

Tag file cấu hình với tag là `apache`, sau đó ấn nút `Update tags`

![graylog](/images/step6.png)

**Step 8**
Khi bạn start Sidecar với tag `apache` sẽ có output :

![graylog](/images/step7.png)
	
### 2. Cài đặt trên Client	

Trên client, chỉ cần tải script về và chạy. 

**Chú ý** : Chỉnh sửa thông số thông số **tag** trong file cấu hình `/etc/graylog/collector-sidecar/collector_sidecar.yml` cho đúng với cấu hình tại Step 7.

 - Với Client là Ubuntu 14.04
 
```sh
wget https://raw.githubusercontent.com/hocchudong/ghichep-graylog/master/scripts/graylog-client-ubuntu14.sh
bash graylog-client-ubuntu14.sh
```

 - Với Client là Ubuntu 16.04
 
```sh
wget https://raw.githubusercontent.com/hocchudong/ghichep-graylog/master/scripts/graylog-client-ubuntu16.sh
bash graylog-client-ubuntu16.sh
```

 - Với Client là Centos 6
 
```sh
wget https://raw.githubusercontent.com/hocchudong/ghichep-graylog/master/scripts/graylog-client-centos6.sh
bash graylog-client-centos6.sh
```

 - Với Client là Centos 7
 
```sh
wget https://raw.githubusercontent.com/hocchudong/ghichep-graylog/master/scripts/graylog-client-centos7.sh
bash graylog-client-centos7.sh
```

Sau khi cài xong trên client, truy cập vào giao diện Dashboard để kiểm tra. Kết quả như ảnh sau là việc cài đặt trên Client đã thành công.

![graylog](/images/graylog-install03.png)

Kiểm tra lại log đã nhận trong mục `Search`

![graylog](/images/graylog-install04.png)
