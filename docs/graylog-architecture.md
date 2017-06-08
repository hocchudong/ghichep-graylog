## I. Khuyến cáo về sizing các thành phần
 - Graylog-node : Cần dùng nhiều CPU. 
 - Elasticsearch : Nên cung cấp nhiều RAM nhất có thể và tốc độ ổ cứng nhanh nhất. Tất cả phụ thuộc vào tốc độ I/O.
 - MongoDB : Chỉ lưu trữ metadata và configuration data nên không cần nhiều tài nguyên.

**Lưu ý** : Tất cả các message được nhận đều lưu trữ trong Elasticsearch. Cần có phương án backup và dự phòng cho Elasticsearch Cluster.

## II. Mô hình cài đặt minimum-setup 

![graylog](/images/small-architecture.png)

Mô hình cài đặt áp dụng cho các hệ thống nhỏ, không bảo mật hoặc mô hình test.

## III. Mô hình cài đặt Bigger-production setup

![graylog](/images/bigger-architecture.png)

Load balancer có thể ping đến các node Graylog thông qua HTTP trên Graylog REST API để kiểm tra tình trạng các node