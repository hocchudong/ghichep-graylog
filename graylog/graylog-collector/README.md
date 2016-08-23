###Giới thiệu
Graylog Collector là một ứng dụng Java kích thước nhẹ cho phép bạn chỏ cụ thể data từ log files tới một Graylog Cluster. Collector có thể đọc log files local ( Ví dụ apache, openvpn,...), nói chung bất cứ dịch vụ nào có ghi log  và cả trên Window.

###Cách cài đặt Graylog Collector trên Linux

Máy cài đặt Graylog Collector phải có Java >= 7, kiểm tra :
<ul>root@controller:~# cd /usr/lib/jvm/</ul>
<ul>root@controller:/usr/lib/jvm# ll</ul>
<img src="http://i.imgur.com/zAvIbTh.png">

####Step 1 : Cài đặt Java jdk 7 :

	root@controller:~# apt-get update
	
	root@controller:~# apt-get install openjdk-7-jdk -y

###Cài đặt Graylog Collector theo hướng dẫn tại trang chủ : http://docs.graylog.org/en/1.2/pages/collector.html

####Ví dụ, trên Ubuntu 14.04 : 
	root@controller:~#wget https://packages.graylog2.org/repo/packages/graylog-collector-latest-repository-ubuntu14.04_latest.deb
	root@controller:~#dpkg -i graylog-collector-latest-repository-ubuntu14.04_latest.deb
	root@controller:~#apt-get install apt-transport-https
	root@controller:~#apt-get update
	root@controller:~#apt-get install graylog-collector -y

###Sau khi chạy các lệnh trên ta cần set $JAVA_HOME như sau : 

####Step 2 : Thay biến JAVA_HOME
	root@controller:~# vi /etc/environment 
		JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"	( thêm dòng này vào )
####Step 3 : Chạy biến

	root@controller:~# source /etc/environment 
	
Kiểm tra xem đã thiết lập thành công chưa với câu lệnh :

	root@controller:~# echo $JAVA_HOME 
	
Output hiển thị nên là đường dẫn tới thư mục java :

		JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"
		
####Step 4 : Cấu hinh GraylogCollector, tại đây ta cấu hình những định dạng log mà ta muốn đẩy về GraylogServer, ví dụ như sau 
	root@controller:~# vi /etc/graylog/collector/collector.conf
	server-url = "http://10.0.0.17:12900"
	collector-id = "file:/etc/graylog/collector/collector-id"
	inputs {
	  syslog {
	    type = "file"
	    path = "/var/log/syslog"
	  }
	}
	outputs {
	  graylog-server {
	    type = "gelf"
	    host = "10.0.0.17"
	    port = 12201
	  }
	}
####Step 5 : Phân quyền cho graylog-collector
	root@controller:~#gpasswd -a graylog-collector adm
	root@controller:~#gpasswd -a graylog-collector root

####Step 6 :Khởi động GraylogCollector
	root@controller:~# service graylog-collector start
Sau khi khởi động, vào web interface của graylog kiểm tra ( chú ý [cấu hình input cho graylog-webinterface](https://github.com/hocchudong/ghichep-graylog/blob/master/graylog/graylog-collector/GELF%20Input%20for%20graylog-collector.md) để nhận log từ trước đó )
#### Chú ý : 
* 1. Sử dụng graylog-collector.sh để cài đặt, thì sau khi chạy file xong, vẫn phải vào file cấu hình collector.conf để cấu hình các file log muốn đẩy về.
* 2. Với Ubuntu 12.04, khi cài đặt collector thì phải phân quyền thư mục đọc log với quyền 644 
Ví dụ : Khi muốn đọc log từ /var/log/syslog, cần phân quyền như sau <img src="http://i.imgur.com/PNa6o6Z.png">
