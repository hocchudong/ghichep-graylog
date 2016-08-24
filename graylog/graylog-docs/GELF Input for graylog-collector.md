###Hướng dẫn cấu hình GELF Input trên Graylog-WebInterface để nhận bản tin log từ Collector trên máy Client đẩy về

GELF TCP là input chuyên dùng cho Graylog collector, cấu hình như sau 
<img src="http://i.imgur.com/3hDe9sR.png">

Sau khi launch input mới, ta nhập các thông tin cần thiết vào bảng

<img src="http://i.imgur.com/7AILvUm.png">
<img src="http://i.imgur.com/qLixEKT.png">

Một số mục cần lưu ý khi nhập thông tin :

<li>	Bind IP : Nhập IP của Graylog-Server  hoặc 0.0.0.0 ( Nếu đặt 0.0.0.0 Graylog server sẽ lắng nghe tất cả các bản tin trả về, chỉ đặt nếu đã thiết lập IPTables)</li>
<li>  Port : Chú ý đặt trùng với port thiết lập trong file config của máy Collector Client ( mặc định của cả 2 là 12201 ) </li>
<li>	Bạn có thể tìm hiểu thêm về cơ chế đẩy log với TLS để sử dụng TLS với Graylog-Colector để bảo mật tốt hơn khi truyền các bản tin log.</li>

Sau khi launch xong input, cần có 2 phần của Input cần lưu ý

<img src="http://i.imgur.com/nlpxoON.png">
#####1 : Kiểm tra xem các bản tin log đã được đẩy về hay chưa. ( Các bản tin sẽ bắt đầu đẩy về sau khi graylog-collector service khởi động )
#####2 : Quản lý các extractor được tạo ở phần searching. 
