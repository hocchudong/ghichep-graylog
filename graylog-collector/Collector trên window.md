###Cài đặt Graylog Collector trên Window 
Trước khi cài đặt, ta cần cài đặt Java jdk phiên bản >= 7, và sau đó set biến $JAVA_HOME. Tham khảo tại link :
https://confluence.atlassian.com/doc/setting-the-java_home-variable-in-windows-8895.html

####Step 1 : Dowload gói GraylogCollector tại link : https://github.com/Graylog2/collector#binary-download
Chọn định dạng file zip, sau khi dow về thì giả nén vào thư mục ổ C 
<img src="http://i.imgur.com/qBQD2tD.png">
####Step 2 : Chỉnh sửa cấu hình tại thư mục, chú ý sau khi cấu hình xong, remove file collector.conf.example để tránh trùng url
<img src="http://i.imgur.com/kFlrsuD.png">
<ul>Trong file cấu hình, thiết lập các bản tin log muốn đẩy về, ví dụ như sau</ul>
<img src="http://i.imgur.com/CNCYbjp.png">
####Step 3 : Cài đặt và khởi động GraylogCollector, ta làm như sau :
<img src="http://i.imgur.com/8e677qU.png">
####Step 4 : Kiểm tra trên web interface xem Collector đã được đẩy về hay chưa 
<img src="http://i.imgur.com/z8cVf4L.png">
