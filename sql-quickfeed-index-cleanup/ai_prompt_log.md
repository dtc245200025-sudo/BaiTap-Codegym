# Nhật ký tra cứu với AI

## Cardinality thấp ảnh hưởng thế nào đến B-Tree?

**Câu hỏi:** Vì sao index Boolean thường không giúp truy vấn khi 99% bản ghi có cùng giá trị?

**Tóm tắt:** Index phải trả về gần toàn bộ khóa rồi đọc gần toàn bộ hàng. Random I/O và việc quay lại clustered index có thể đắt hơn quét bảng tuần tự, nên optimizer thường bỏ index.

## Index trên TEXT gây tốn tài nguyên ra sao?

**Câu hỏi:** Index tiền tố 255 ký tự của `content` tác động tới RAM, disk và thao tác ghi thế nào?

**Tóm tắt:** Mỗi khóa lớn làm các page chứa ít entry hơn, cây lớn và sâu hơn, buffer pool chứa được ít phần hữu ích hơn. INSERT phải ghi thêm index page và có thể gây page split. Tìm kiếm từ tự do nên dùng FULLTEXT.

## InnoDB lưu Data và Index Pages thế nào?

**Câu hỏi:** `data_length` và `index_length` trong `information_schema.TABLES` biểu diễn gì?

**Tóm tắt:** Với InnoDB, `data_length` chủ yếu phản ánh clustered index chứa hàng; `index_length` phản ánh các secondary index. Đây là số liệu phân bổ theo page/extent và có thể chưa giảm tức thời giống kích thước file vật lý.

## Nhiều index tác động INSERT thế nào?

**Câu hỏi:** Xóa ba trong năm secondary index cải thiện ghi ra sao?

**Tóm tắt:** Mỗi INSERT giảm từ năm xuống hai lần cập nhật secondary B-Tree. Điều này giảm ghi log, dirty page, CPU, I/O và khả năng tranh chấp; đổi lại một số truy vấn đọc mất đường truy cập riêng.
