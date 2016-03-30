
#Có thể bạn chưa biết ! Những tính năng mà Graylog2.0 có thể làm được !

###Web-Interface đã được tích hợp trong Graylog Server 
- Graylog-web-interface được hợp nhất Graylog-server, code của web-interface được viết lại dưới dạng react.js
- Việc tích hợp giúp Graylog web interface có thể tương tác với các *plugin*, tạo khả năng mở rộng và tùy biến mạnh mẽ.

###Đã support được Elasticsearch version 2.x trở lên.
- Graylog 2.0 chỉ sử dụng Elasticsearch 2.x trở lên. Hãy chú ý rằng Elasticsearch không hỡ trợ việc downgrade, vì vậy hãy cẩn thận trong việc upgrade Elasticsearch v1.x lên v2.x.
 
###Sử dụng cơ chế `Tail -f` với các bản tin
- Với Graylog 2.0, các bản tin log mới nhất sẽ được liên tục tự động cập nhập trên web-interface. 
- Ta có thể chỉnh sửa thời gian cập nhập cho các bản tin mới ( 1-5-10-30s, 5-10-30m... ).

###Cơ chế xử lý log message : `Pipline`
- Cơ chế mới Pipline cho phép bạn viết ra các rule và phối hợp các rule đó để xử lý các message truyền vào.
- Bạn có thể viết một plugin để mở rộng khả năng phổi hợp các rule của pipline, giúp tối đa hóa công suất của hệ thống bằng việc định tuyển, lọc, phân luồng bản tin.

###Map widget
- Tính năng mới giúp bạn visualize các địa chỉ IP lên map. Việc này dựa trên cơ chế phân giải địa chỉ IP thành một vị trí địa lý gần đúng trên bản đồ. ( Giống với tính năng GeoIP trên ELK )

###Archiving Index
- Graylog trước kia cho phép bạn cấu hình để tự động delete những bản tin log cũ nhằm làm nhẹ hệ thống. Tuy nhiên với những khách hàng vẫn muốn lưu trữ những bản tin cũ, nhưng lại không muốn tăng chi phí để nâng cao cấu hình phần cứng cho hệ thống thì sao?

Graylog 2.0 cho phép bạn chuyển một index cũ thành một tập tin dưới dạng file nén. Bạn có thể lưu các index cũ sang một máy storage khác, re-import vào Graylog nếu cần đến hoặc xóa đi nếu không cần thiết.
- Tính năng *Archiving* là tính năng tính phí, người dùng cần phải trả tiền nếu muốn sử dụng chúng.

###Collector Sidecar
- Chúng tôi sẽ cập nhật sớm nhất có thể các điểm nổi bật của tính năng này.

###Stream Filter
- Một tính năng mới giúp bạn lọc các stream cần tìm bằng cách tìm kiếm bằng tittle hoặc description.

###Search surrounding messages - Tìm kiếm xung quanh bản tin log
- Khi bạn đặc biệt quan tâm đến một event có trong một bản tin log nào đó, chức năng này giúp bạn tìm kiếm thêm các bản tin liên quan đến event đó. Các bản tin xảy ra ngay trước hoặc ngay sau event, hoặc xảy ra cùng thời điểm liên quan đến event này.

###Query range limit - Ngưỡng tìm kiếm
- Với Graylog 2.0, bạn có thể đặt khoảng thời gian giới hạn cho việc tìm kiếm các bản tin. Ví dụ, bạn đặt cho các bản tin log này ngưỡng tìm kiếm là 2 tháng. Thì sau 2 tháng, không ai có thể tìm kiếm được các bản tin log này.
- Thời gian tìm kiếm có thể tùy chỉnh lên đến tối đa là 90 ngày ( trước là 30 ngày ).


####Trên đây là một số tính năng tiêu biểu có trong bản Graylog 2.0 Beta 1 !
