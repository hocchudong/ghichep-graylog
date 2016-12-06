#Mục lục
*	[I. Giới thiệu](#I)
	*	[1. Phương thức hoạt động hệ thống Graylog](#1)
	*	[2. Backends](#2)
*	[II. Cài đặt phía client](#II)
	*	[1. Beat Backend](#1)
		*	[1.1. Ubuntu](#1.1)
		*	[1.2. Centos](#1.2)
		*	[1.3. Window](#1.3)
	*	[2. Nxlog Backend](#2)
		*	[2.1. Ubuntu](#2.1)
		*	[2.2. Centos](#2.2)
		*	[2.3. Window](#2.3)		
	*	[3. Các tùy chọn trong file cấu hình](#3)
	*	[4. Khởi động Sidecar](#4)
	*	[5. Sidecar status](#5)
*	[III. Cài đặt phía server](#III)
*	[IV. Một số thuật ngữ](#IV)
#I. Giới thiệu 
<a name="I"> </a> 

##1. Phương thức hoạt động hệ thống Graylog
<a name="1"> </a> 

![graylog](/graylog/images/collector-sidecar.png)

	Điểm khác biệt giữa Graylog phiên bản 2.0 trở lên với các phiên bản Graylog cũ (version <1.3) chính là Graylog 2.0 sử dụng phương thức hoạt động là Graylog Collector Sidecar.

	Với phương thức truyền thống trước kia (Graylog version <1.3), người quản trị sẽ tiến hành cài đặt một agent của graylog-server (graylog-collector) bên phía client, khai báo các thông số cấu hình (
thông số server, thông số file log muốn thu thập...) trong file cấu hình ở phía client, sau đó khởi động agent. Tại phía Graylog-server, trên Web-interface sẽ tiến hành tạo một input để nhận các 
thông số truyền đến từ phía client. Lúc này, Graylog-server chỉ đóng vai trò tiếp nhận và hiển thị, hoàn toàn không can thiệp trực tiếp đến client.
	Với phương thức mới (Graylog version >2.0), người quản trị có thể sử dụng các backend thu thập log có sẵn ( hoặc tạo mới) trên phía client, đồng thời dùng một hệ thống quản lý cấu hình trọng lượng nhẹ (
graylog-collector-sidecar) dùng để quản lý cấu hình của backend. Sau khi khai báo các thông số cần thiết cho collector-sidecar, file cấu hình của các backend
 sẽ được tự động sinh ra. Theo định kỳ, tiến trình Sidecar sẽ thu thập tất cả các cấu hình thích hợp cho target, dùng REST API. Những cấu hình được thu thập dựa vào các 
"tag" trong file cấu hình. Ví dụ, một Web server host bao gồm các tag "linux" và tag "nginx"
	Trong lần đầu tiên chạy, hoặc khi có một sự thay đổi về cấu hình được phát hiện, Sidecar sẽ tạo (hoặc hoàn trả) các file cấu hình backend thích hợp. 
Sau đó nó sẽ start hoặc restart, các log collector sẽ được reconfigured. Lúc này Graylog-server sẽ đóng vai trò điều khiển, tiếp nhận và hiển thị.


##2. Backends
<a name="2"> </a> 

	Hiện giờ Sidecar đang hỗ trợ NXlog, Filebeat và Winlogbeat. Tất cả chúng đều chia sẻ một giao diện web giống nhau. Các tính năng được hỗ trợ hầu hết
giống nhau. Tất cả các collector GELF output được hỗ trợ SSL. Ở phía server, bạn có thể chia sẻ các input với các nhiều collector. Vd, tất cả Filebeat
và Winlogbeat instance có thể gửi log về một Graylog-Beat input.

#II. Cài đặt phía Client
<a name="II"> </a> 
##1. Beat Backend
<a name="1"> </a> 
###1.1 Ubuntu
<a name="1.1"> </a> 
Dowload và cài đặt trong gói collector-sidecar
```sh
wget https://github.com/Graylog2/collector-sidecar/releases/download/0.1.0-alpha.2/collector-sidecar_0.1.0-1_amd64.deb
dpkg -i collector-sidecar_0.1.0-1_amd64.deb
```
Chỉnh sửa file `/etc/graylog/collector-sidecar/collector_sidecar.yml`, thêm URL của Graylog server và tag. Các tag sẽ được dùng để chỉ ra các cấu hình 
host sẽ được nhận. 

![graylog](/graylog/images/sidecar-config-01.png)

Tạo systemc service và start :
```sh
graylog-collector-sidecar -service install
start collector-sidecar
```

###1.2 Centos
<a name="1.2"> </a> 
Cài đặt từ rpm
```sh
wget https://github.com/Graylog2/collector-sidecar/releases/download/0.1.0-alpha.2/collector-sidecar-0.1.0-1.x86_64.rpm
rpm -i collector-sidecar-0.1.0-1.x86_64.rpm
```
Tạo systemc service và start :
```sh
graylog-collector-sidecar -service install
systemctl start collector-sidecar
```

###1.3 Window
<a name="1.3"> </a> 
Tải và chạy file : `collector_sidecar_installer.exe`

Sửa file `C:\Program Files\graylog\collector-sidecar\collector_sidecar.yml` và register service hệ thống :
```sh
C:\Program Files\graylog\collector-sidecar\graylog-collector-sidecar.exe -service install
C:\Program Files\graylog\collector-sidecar\graylog-collector-sidecar.exe -service start
```

##2. NXlog backend
<a name="2"> </a> 
###2.1 Ubuntu
<a name="2.1"> </a> 
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

###2.2 Centos 
<a name="2.2"> </a> 
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

###2.3 Window
<a name="2.3"> </a> 
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

##3 Các tùy chọn cấu hình trong `collector_sidecar.yml`
<a name="3"> </a> 

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

##4 Khởi động Sidecar :
<a name="4"> </a> 

 - Debian/Ubuntu : `sudo start collector-sidecar`
 - RedHat/CentOS : `sudo systemctl start collector-sidecar`
 - Windows		 : `C:\Program Files\graylog\collector-sidecar\graylog-collector-sidecar.exe -service start`
 
Khi Sidecar tìm thấy một cấu hình với tag phù hợp, nó sẽ ghi cho mỗi collector backend một file cấu hình 
vào trong thư mục `/generated`. Ví dụ, nếu bạn bật Filebeat collector bạn sẽ tìm thấy một file `filebeat.yml` trong thư mục trong thư mục này.
Tất cả các thay đổi được tạo trên Graylog Web interface. Mỗi lần Sidecar tìm thấy một update cấu hình thì nó sẽ rewrite trong gile cấu hình collector tương ứng.
Sidecar sẽ đảm nhiệm việc giám sát các tiến trình collector mỗi khi có thay đổi và report trạng thái trở lại cho web interface.

##5. Sidecar Status
<a name="5"> </a> 

Mỗi Sidecar instance có thể gửi lại thông tin tình trạng cho Graylog. Bằng việc mở option `send_status`, các metric như là các tag được cấu hình hoặc địa chỉ IP
của host Sidecar đang chạy trên đó sẽ được gửi. Với `list-log-files` option thì thư mục listing sẽ được hiển thị trên Graylog web interface, nhờ đó admin có teher nhìn thấy file nào đang sẵn 
sàng để thu thập. List này sẽ được update theo đình kỳ và các file với quyền ghi sẽ được highlight để dễ nhận biết. Sau khi enable `send_status` hoặc `send_status+list_log_files`, đi tới mục collector overview và click 
vào một trong chúng, một trang trạng thái với các thông tin cấu hình sẽ được hiển thị.

#III. Cài đặt phía Server
<a name="III"> </a> 

Các cài đặt được thực hiện toàn bộ trên Web-interface.

Sau khi bên phía client khởi động collector-sidecar, các collector sẽ hiển thị tại phần **1**. Click vào mục **3** để thực hiện tùy chỉnh các cấu hình cho các collector.


![graylog](/graylog/images/sidecar-config-02.png)
![graylog](/graylog/images/sidecar-config-03.png)

Cấu hình collector trên web sẽ dựa vào các **tag** để nhận biết các collector-sidecar phía client. Thực hiện thêm tag trong file cấu hình :

![graylog](/graylog/images/sidecar-config-04.png)

Tiếp tục thực hiện khai báo Output (output sẽ là Graylog-server) như sau : 

![graylog](/graylog/images/sidecar-config-05.png)

Khai báo Input bao gồm : tên Input, Output mà log sẽ đẩy đến, loại backend, đường dẫn tới file log cần lấy, loại file cầu lấy.

![graylog](/graylog/images/sidecar-config-06.png)

Sau khi khai báo xong, kiểm tra tình trạng của các client :

![graylog](/graylog/images/sidecar-config-07.png)
![graylog](/graylog/images/sidecar-config-08.png)

##IV. Một số thuật ngữ
<a name="IV"> </a> 

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

