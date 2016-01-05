###Giới thiệu
Graylog Collector là một ứng dụng Java kích thước nhẹ cho phép bạn chỏ data từ log files tới một Graylog Cluster. Collector có thể đọc log files local và Window Event.

###Cách cài đặt Graylog Collector trên Linux

Máy cài đặt Graylog Collector phải có Java >= 7, kiểm tra với câu lệnh :

root@Ubuntu:~# java -version

####Step 1 : Cài đặt Java jdk 7 :
root@controller:~# apt-get update
root@controller:~# apt-get install openjdk-7-jdk -y

Cài đặt Graylog Collector theo hướng dẫn tại trang chủ : http://docs.graylog.org/en/1.2/pages/collector.html

####Ví dụ, trên Ubuntu 14.04 : 
<ul>root@controller:~#sudo wget https://packages.graylog2.org/repo/packages/graylog-collector-latest-repository-ubuntu14.04_latest.deb</ul>
<ul>root@controller:~#sudo dpkg -i graylog-collector-latest-repository-ubuntu14.04_latest.deb</ul>
<ul>root@controller:~#sudo apt-get install apt-transport-https</ul>
<ul>root@controller:~#sudo apt-get update</ul>
<ul>root@controller:~#sudo apt-get install graylog-collector -y</ul>

###Sau khi chạy các lệnh trên ta cần set $JAVA_HOME như sau : 

####Step 2 : Thay biến JAVA_HOME
	root@compute1:~# vi /etc/environment 
		JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"	( thêm dòng này vào )
####Step 3 : Chạy biến
	root@compute1:~# source /etc/environment 
	Kiểm tra xem đã thiết lập thành công chưa với câu lệnh :
	root@compute1:~# echo $JAVA_HOME 
	
	Output hiển thị nên là đường dẫn tới thư mục java :
		JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"
####Step 4 : Cấu hinh GraylogCollector, tại đây ta cấu hình những định dạng log mà ta muốn đẩy về GraylogServer, ví dụ như sau 
	root@compute1:~# vi /etc/graylog/collector/collector.conf
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



####Step 5 :Khởi động GraylogCollector
	root@compute1:~# service graylog-collector start
Sau khi khởi động, vào web interface của graylog kiểm tra ( chú ý cấu hình input cho graylog server để nhận log từ trước đó )
* Chú ý : Sử dụng graylog-collector.sh để cài đặt, thì sau khi chạy file xong, vẫn phải vào file cấu hình collector.conf để cấu hình các file log muốn đẩy về.
