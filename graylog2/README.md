# CÁC CHÚ Ý KHI CÀI ĐẶT GRAYLOG 

### NGUỒN TÀI LIỆU
Modified script from https://github.com/mrlesmithjr/graylog2
Changed a few settings and cut out others to customize for personal use for up to date (1/15/15) install of Graylog2/ES/Mongo
Credits to mrlesmithjr for original.

### CÁC CHÚ Ý
##### CHÚ Ý VỀ VIỆC HIỂN THỊ THỜI GIAN TRÊN GIAO DIỆN WEB 
* Mặc định trên web sẽ hiện thị theo thời gian UTC (dùng lệnh `date -u` để hiện thị thời gian theo UCT). Minh họa về giờ bị sai lệch: http://prntscr.com/5v39ll
* Để chỉnh giờ theo giờ VIỆT NAM thì chỉnh ở file sau, file cấu hình web của GRAYLOG2
```sh
vi /opt/graylog2-web-interface/conf/graylog2-web-interface.conf
```

* Sửa dòng 17 (trong bản 0.9.4) thành `timezone="Asia/Ho_Chi_Minh"` giống như hình minh họa: http://prntscr.com/5v39zm

### VẤN ĐỀ VỀ TÌM KIẾM TRONG GRAYLOG2

- Đến số lần đăng nhập thành công trong ssh
```sh
message:" pam_unix(sshd:auth): authentication failure" AND message:" user=" AND application_name:sshd
```

### VẤN ĐỀ VỀ Graylog2 extractors

Trong Graylog có kỹ thuật cắt lọc các ký tự, các nội dung trong bản tin log, ví dụ dưới :

* Nội dung bản tin: 
```sh 
Failed password for invalid user adfsdf from 172.16.69.1 port 14026 ssh2
```
* Sử dụng cú pháp `Regular expression` để lọc ra từ `adfsdf`
```sh
^.*user (.+) from\b
```

- KẾT QUẢ
![Minh họa](http://i.imgur.com/xcXWOi0.png)

* Lấy ra code http trong bản tin sau
```sh
- Bản tin
172.16.69.1 - - [24/Jan/2015:14:24:00 +0700] "GET /phpipam/subnets/3/ HTTP/1.1" 200 5832 "http://172.16.69.22/phpipam/" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) coc_coc_browser/45.0 Chrome/39.0.2171.103 Safari/537.36"

- Cú pháp
^.*HTTP/1.1" (.+?)\s\b
```

- KẾT QUẢ
![Kết quả](http://i.imgur.com/m3yK91F.png)

