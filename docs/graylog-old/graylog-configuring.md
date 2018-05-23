# I. Graylog Collector Sidecar
Graylog Collector Sidecar là một hệ thống quản lý cấu hình cho các log collector khác nhau, được gọi là các **Backend*. Graylog node hoạt động như một
hub tập trung chứa các cấu hình của các log collector

![graylog](/imagescollector-sidecar.png)

Các cấu hình được quản lý tập trung thông qua giao diện Graylog Web. Với những yêu cầu riêng, các cấu hình raw backend, Snippet được gọi, và có thể
tùy chọn lưu trữ trực tiếp trong Graylog.
Theo định kỳ, tiến trình Sidecar sẽ thu thập tất cả các cấu hình thích hợp cho target, dùng REST API. Những cấu hình được thu thập dựa vào các 
"tag" trong file cấu hình. Ví dụ, một Web server host bao gồm các tag "linux" và tag "nginx"
Trong lần đầu tiên chạy, hoặc khi có một sự thay đổi về cấu hình được phát hiện, Sidecar sẽ tạo (hoặc hoàn trả) các file cấu hình backend thích hợp. 
Sau đó nó sẽ start hoặc restart, các log collector sẽ được reconfigured.
Graylog Collector Sidecar (được viết bằng Go) và các backend (được viết bằng các ngôn ngữ khác nhau, C hoặc Go)

# II. Backends
Hiện giờ Sidecar đang hỗ trợ NXlog, Filebeat và Winlogbeat. Tất cả chúng đều chia sẻ một giao diện web giống nhau. Các tính năng được hỗ trợ hầu hết
giống nhau. Tất cả các collector GELF output được hỗ trợ SSL. Ở phía server, bạn có thể chia sẻ các input với các nhiều collector. Vd, tất cả Filebeat
và Winlogbeat instance có thể gửi log về một Graylog-Beat input.

# III. Cài đặt
## 1. Beat Backend
### 1.1 Ubuntu
Dowload và cài đặt trong gói collector-sidecar
```sh
wget https://github.com/Graylog2/collector-sidecar/releases/download/0.1.0/collector-sidecar_0.1.0-1_amd64.deb
dpkg -i collector-sidecar_0.1.0-1_amd64.deb
```
Chỉnh sửa file `/etc/graylog/collector-sidecar/collector_sidecar.yml`, thêm URL của Graylog server và tag. Các ag sẽ được dùng để chỉ ra các cấu hình 
host sẽ được nhận.
Tạo systemc service và start :
```sh
graylog-collector-sidecar -service install
start collector-sidecar
```

### 1.2 Centos
Cài đặt từ rpm
```sh
wget https://github.com/Graylog2/collector-sidecar/releases/download/0.1.1/collector-sidecar-0.1.1-1.x86_64.rpm
rpm -i collector-sidecar-0.1.1-1.x86_64.rpm
```
Tạo systemc service và start :
```sh
graylog-collector-sidecar -service install
systemctl start collector-sidecar
```

### 1.3 Window
Tải và chạy file : `collector_sidecar_installer.exe`

Sửa file `C:\Program Files\graylog\collector-sidecar\collector_sidecar.yml` và register service hệ thống :

```sh
server_url: http://172.17.40.37:9000/api 
update_interval: 10
tls_skip_verify: false
send_status: true
list_log_files:
node_id: app-ser-thanhtr-172.16.32.38
collector_id: file:C:\Program Files\graylog\collector-sidecar\collector-id
cache_path: C:\Program Files\graylog\collector-sidecar\cache
log_path: C:\Program Files\graylog\collector-sidecar\logs
log_rotation_time: 86400
log_max_age: 604800
tags: [windows]
backends:
    - name: nxlog
      enabled: false
      binary_path: C:\Program Files (x86)\nxlog\nxlog.exe
      configuration_path: C:\Program Files\graylog\collector-sidecar\generated\nxlog.conf
    - name: winlogbeat
      enabled: true
      binary_path: C:\Program Files\graylog\collector-sidecar\winlogbeat.exe
      configuration_path: C:\Program Files\graylog\collector-sidecar\generated\winlogbeat.yml
    - name: filebeat
      enabled: false
      binary_path: C:\Program Files\graylog\collector-sidecar\filebeat.exe
      configuration_path: C:\Program Files\graylog\collector-sidecar\generated\filebeat.yml
```
 - Khởi động dịch vụ
 
```sh
"C:\Program Files\graylog\collector-sidecar\graylog-collector-sidecar.exe" -service install
"C:\Program Files\graylog\collector-sidecar\graylog-collector-sidecar.exe" -service start
```

## 2. NXlog backend
### 2.1 Ubuntu
Cài đặt NXLog package từ trang dowload : http://nxlog.co/products/nxlog-community-edition/download . Cần stop tất cả các instance đã cài đặt NXlog
và cấu hình lại. Sau đó có thể cài đặt Sidecar 
```sh
/etc/init.d/nxlog stop
update-rc.d -f nxlog remove
gpasswd -a nxlog adm
chown -R nxlog.nxlog /var/spool/collector-sidecar/nxlog
wget https://github.com/Graylog2/collector-sidecar/releases/download/0.1.0-alpha.2/collector-sidecar_0.1.0-1_amd64.deb
dpkg -i collector-sidecar_0.1.0-1_amd64.deb
```
Chỉnh sửa file `/etc/graylog/collector-sidecar/collector_sidecar.yml`. Tạo systemc service và start :
```sh
graylog-collector-sidecar -service install
start collector-sidecar
```

### 2.2 Centos 
```sh
/etc/init.d/nxlog stop
update-rc.d -f nxlog remove
gpasswd -a nxlog adm
chown -R nxlog.nxlog /var/spool/collector-sidecar/nxlog
wget https://github.com/Graylog2/collector-sidecar/releases/download/0.1.0-alpha.2/collector-sidecar-0.1.0-1.x86_64.rpm
rpm -i collector-sidecar-0.1.0-1.x86_64.rpm
```
Tạo systemc service và start :
```sh
graylog-collector-sidecar -service install
systemctl start collector-sidecar
```

### 2.3 Window
Tải file và deactive nxlog trước khi cài đặt :
```sh
C:\Program Files (x86)\nxlog\nxlog -u
collector_sidecar_installer.exe
```

Sửa file `C:\Program Files\graylog\collector-sidecar\collector_sidecar.yml` và register service hệ thống :
```sh
C:\Program Files\graylog\collector-sidecar\graylog-collector-sidecar.exe -service install
C:\Program Files\graylog\collector-sidecar\graylog-collector-sidecar.exe -service start
```

Để uninstall trên Window :
```sh
C:\Program Files\graylog\collector-sidecar\graylog-collector-sidecar.exe -service stop
C:\Program Files\graylog\collector-sidecar\graylog-collector-sidecar.exe -service uninstall
```

### 2.4 Các tùy chọn cấu hình trong `collector_sidecar.yml`
File cấu hình được chia thành global option và backend option. 
Các global option :
 - server_url : URL của Graylog API , vd : `http://127.0.0.1:9000/api/`
 - update_interval : Khoảng thời gian theo giây, sidecar sẽ thu thập các cấu hình mới từ Gralog server
 - tls_skip_verify : từ chối các lỗi khi REST API được khởi động với self-singed certificate
 - send_status : Gửi trả status với mỗi backend tới Graylog và hiển thị nó trên status page cho host
 - list_log_files : Gửi một thư mục tới Graylog và hiển thị nó trên host status page
 - node_id : Tên của Sidecar instance sẽ hiện lên trên web interface. Nếu không đặt thì sẽ dùng hostname thay thế
 - collector_id : UUID của instance. Có thể là một string hoặc 1 đường dẫn tới một ID file
 - log_path : 1 đường dẫn tới 1 thư mục nơi mà Sidecar có thể store output của mỗi collector backend đang chạy.
 - log_rotation_time : Xoay vòng stdout và stderr log của mỗi collector sau X giây.
 - log_max_age : xóa rotated log file sau Y giây.
 - tags : Danh sách các tag cấu hình. Tất cả các cấu hình trên phía server side sẽ match với tag list sẽ được thu thập và merged bởi instance này.
 - backends : Một list các collector backend mà user muốn chạy target host

Các backend hiện thời là NXlog và Beats, Sidecar cầ biết binary nào đã được cài đặt và nơi nào nó có thể được ghi file cấu hình :
 - name : Backend nào được dùng (nxlog, filebeat hoặc winlogbeat)
 - enable : các backend có được khởi động bởi Sidecar hay không
 - binary_path : đường dẫn tới collector binary
 - configuration_path : đường ẫn tới file cấu hình cho collector này

 Ví dụ cho 1 file cấu hình cho NXlog :
```sh
server_url: http://10.0.2.2:9000/api/
update_interval: 30
tls_skip_verify: true
send_status: true
list_log_files:
  - /var/log
node_id: graylog-collector-sidecar
collector_id: file:/etc/graylog/collector-sidecar/collector-id
log_path: /var/log/graylog/collector-sidecar
log_rotation_time: 86400
log_max_age: 604800
tags:
  - linux
  - apache
  - redis
backends:
    - name: nxlog
      enabled: true
      binary_path: /usr/bin/nxlog
      configuration_path: /etc/graylog/collector-sidecar/generated/nxlog.conf
```

Với Beat platform bạn có thể enable mỗi Beat một cách đơn lẻ, vd trên một Window host với Filebeat và Winlogbeat được enable ử dụng một cấu hình như :
```sh
server_url: http://10.0.2.2:9000/api/
update_interval: 30
tls_skip_verify: true
send_status: true
list_log_files:
  - /var/log
node_id: graylog-collector-sidecar
collector_id: file:/etc/graylog/collector-sidecar/collector-id
log_path: /var/log/graylog/collector-sidecar
log_rotation_time: 86400
log_max_age: 604800
tags:
  - linux
  - apache
  - redis
backends:
    - name: winlogbeat
      enabled: true
      binary_path: C:\Program Files\graylog\collector-sidecar\winlogbeat.exe
      configuration_path: C:\Program Files\graylog\collector-sidecar\generated\winlogbeat.yml
    - name: filebeat
      enabled: true
      binary_path: C:\Program Files\graylog\collector-sidecar\filebeat.exe
      configuration_path: C:\Program Files\graylog\collector-sidecar\generated\filebeat.yml

```

### 2.5 Khởi động Sidecar :
 - Debian/Ubuntu : `sudo start collector-sidecar`
 - RedHat/CentOS : `sudo systemctl start collector-sidecar`
 - Windows		 : `C:\Program Files\graylog\collector-sidecar\graylog-collector-sidecar.exe -service start`
 
Khi Sidecar tìm thấy một cấu hình với tag phù hợp, nó sẽ ghi cho mỗi collector backend một file cấu hình 
vào trong thư mục `/generated`. Ví dụ, nếu bạn bật Filebeat collector bạn sẽ tìm thấy một file `filebeat.yml` trong thư mục trong thư mục này.
Tất cả các thay đổi được tạo trên Graylog Web interface. Mỗi lần Sidecar tìm thấy một update cấu hình thì nó sẽ rewrite trong gile cấu hình collector tương ứng.
Sidecar sẽ đảm nhiệm việc giám sát các tiến trình collector mỗi khi có thay đổi và report trạng thái trở lại cho web interface.

## 3. Sidecar Status
Mỗi Sidecar instance có thể gửi lại thông tin tình trạng cho Graylog. Bằng việc mở option `send_status`, các metric như là các tag được cấu hình hoặc địa chỉ IP
của host Sidecar đang chạy trên đó sẽ được gửi. Với `list-log-files` option thì thư mục listing sẽ được hiển thị trên Graylog web interface, nhờ đó admin có teher nhìn thấy file nào đang sẵn 
sàng để thu thập. List này sẽ được update theo đình kỳ và các file với quyền ghi sẽ được highlight để dễ nhận biết. Sau khi enable `send_status` hoặc `send_status+list_log_files`, đi tới mục collector overview và click 
vào một trong chúng, một trang trạng thái với các thông tin cấu hình sẽ được hiển thị.

### 3.1 Cài đặt Sidecar Step-by-step
**Backend là FileBeat**

**Step 1**
Tạo **Beat input** để collector có thể gửi data đến. Click vào `System -> Input` và khởi động một global Beat input với địa chỉ là 0.0.0.0 và port 5044.

![graylog](/imagesstep1.png)

**Step 2**

Chuyển qua cấu hình collector. Trên Graylog Webinterface click vào : System -> Collectors -> Manage configurations

![graylog](/imagesstep2.png)

**Step 3**

Tạo một cấu hình mới

![graylog](/imagesstep3-1.png)

**Step 4**

Thêm tên cho cấu hình

![graylog](/imagesstep3-2.png)

**Step 5**

Click vào cấu hình mới và tạo Filebeat output.

![graylog](/imagesstep4.png)

**Step 6**

Tạo Filebeat file input để thu thập Apache log

![graylog](/imagesstep5.png)

**Step 7**

Tag file cấu hình với tag là `apache`, sau đó ấn nút `Update tags`

![graylog](/imagesstep6.png)

**Step 8**
Khi bạn start Sidecar với tag `apache` sẽ có output :

![graylog](/imagesstep7.png)

## 4. Bảo mật giao tiếp Sidecar

Giao tiếp giữa Sidecar và Graylog có thể được bảo mật nếu API của sử dụng SSL.

Để bảo mật giao tiếp giữa Collector và Graylog bạn chỉ cần bật `Enable TLS`  trong Beat Input. Nếu không có thông tin thêm vào, Graylog sẽ tạo một 
self-singed certificate cho Input này. Trong Sidecar Beat Output Configuration, bạn cần bật `Enable TLS Support` và `Insecure TLS connection`.
Sau khi save, giao tiếp giữa Beats và Graylog sẽ dùng TLS.

Nếu nạn muốn NXlog bạn cần bật `Allow unstrusted certificate` trong NXLog Output configuration và `Enable TLS` cho GELF input.

### 4.1 Certificate dựa vào xác thực client
Nếu bạn muốn cho phép Graylog chỉ chấp nhận các data từ các client đã được cấp certificate bạn bận xây dựng xác thực certificate và cung cấp nó cho
Input và Client Output configuration

## 5. Một số thuật ngữ

**Configuration** : chỉ `collector configuration file`. Nó chứa một trong nhiều Outputs, Inputs và Snippets. Dựa vào backend được lựa chọn Sidecar sẽ 
tạo một file cấu hình làm việc cho collector cụ thể. Để match một cấu hình cho Sidecar instance, cả 2 phía cần được khởi động với tag giống nhau. Nếu 
các tag của Sidecar instance match với nhiều cấu hình Outputs, Input và Snippets sẽ được hợp nhất cùng nhau thành một configuration đơn.

**Tags** : Các tag được dùng để match các Sidecar instance với các cấu hình ở phía Graylog server.
Vd : một user có thể tạo một cấu hình cho Apache access log files. Cấu hình nhận tag là `apache`. Trên tất cả các web server đang chạy Apache daemon, 
Sidecar sẽ khởi động với tag `apache` để tìm cấu hình phù hợp và thu thập web access log file. Có thể có nhiều tag từ cả 2 phía Sidecar và Graylog server.
Nhưng nên để tỷ lệ 1:1 hoặc 1:n

**Output** : Output được dùng để gửi data từ một collector trở lại Graylog Server.

VD : NXLpog gửi trực tiếp message trong GELF format. GELF output sẽ tạo trong NXlog configuration.

**Input** : Input là một phương thức để collector thu thập data. Một input có thể là một log file mà collector nên tiếp tục đọc hoặc một connection tới 
Windows event system, nới phát ra log event. Input được kết nối tới output. Môt output có thể kết nối tới nhiều input.

**Snippet** : Snippet là một đoạn cấu hình plain text đơn giản.

VD : 1 user muốn load một module collector đặc biệt. Người dùng có thể đẩy trực tiếp vào một snippet, cái mà sau sẽ thêm cấu hình collector cuối cùng
mà không có sự sửa đổi nào. Còn có thể đẩy tất cả file cấu hình vào một snippet và giữ tất cả các kỹ thuật input và output. Bên canh đó snippet được tạo vào
file cấu hình của Sidecar để gửi nó thông qua một template engine. Một snippet được dùng `nxlog-default` snippet. Nó phát hiện Sidecar nào đang chạy, dựa vào
kết quả, các đường dẫn tới một vào thay đổi về collector setting.4

