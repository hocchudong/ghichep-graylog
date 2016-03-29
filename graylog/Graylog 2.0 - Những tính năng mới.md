
#Có thể bạn chưa biết ! Những tính năng mà Graylog2.0 có thể làm được !

- Đã support được *Elasticsearch version 2.x* trở lên. 
- *Tail -f* bản tin log. Giờ đây bạn có thể xem sự thay đổi của các bản tin log mới nhất theo từng giây mà không cần phải Reload. 
- Cơ chế xử lý log mới : *Pipline* ! Cơ chế xử lý log theo các rule giúp bạn xử lý các log đến theo bất kỳ cách nào bạn muốn. 
- *GEOIP* : Chuyển đổi IP thành vị trí địa lý. Giống như ELK, giờ đây Graylog đã có thể visualize các địa chỉ IP trên Map.
- *Archiving* : Graylog cho phép thiết lập việc lưu trữ, xóa log cũ... ngay trên Web-interface
- *Stream Filter* : Với những hàng trăm Stream, việc lọc và tìm kiếm với keyword là vô cùng cần thiết.
- *Search surrounding messages* : Tính năng này cho phép bạn tìm kiếm thêm các thông tin trước và sau khi event được xảy ra.
- *Query range limit* : Cho phép giới hạn thời gian tìm kiếm 1 bản tin log. Ví dụ nếu thời gian giới hạn là 10 phút, thì bạn không thể searc bản tin log đó sau 10 phút
- *Configurable query ranges* : Giờ đây bạn có thể điều chỉnh khoảng thời gian để query một bản tin log linh hoạt hơn !

Đây là một số tính năng tiêu biểu có trong bản Graylog 2.0 Beta1 !
