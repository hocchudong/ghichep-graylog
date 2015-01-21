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

