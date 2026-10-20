# Nhật ký trao đổi với AI

## Covering Index là gì?

**Câu hỏi:** Vì sao index chứa cả cột lọc và cột SELECT có thể tránh đọc bảng?

**Tóm tắt:** Secondary index đã chứa mọi giá trị cần trả về, nên storage engine không cần dùng khóa chính để quay lại clustered index. EXPLAIN thường hiển thị `Using index`.

## Clustered và Secondary Index trong InnoDB

**Câu hỏi:** Secondary index trỏ tới hàng dữ liệu bằng gì?

**Tóm tắt:** InnoDB lưu hàng trong clustered index theo primary key. Lá của secondary index chứa khóa secondary cùng primary key; lấy cột ngoài index cần một lần lookup vào clustered index.

## Tính kích thước entry

**Câu hỏi:** Thêm ba cột `DECIMAL(5,2)`, `DECIMAL(5,2)` và `VARCHAR(20)` làm index tăng thế nào?

**Tóm tắt:** Ngoài byte dữ liệu còn có length byte, record header, primary key và page overhead. `VARCHAR` thay đổi theo chuỗi và charset. Vì vậy phép tính byte chỉ là ước lượng; `information_schema.TABLES.index_length` là số đo phù hợp để so sánh trên cùng máy chủ.

## Write Penalty

**Câu hỏi:** Vì sao entry index rộng làm INSERT chậm?

**Tóm tắt:** Page chứa ít entry hơn, cây cần nhiều page và I/O hơn, buffer pool nhanh đầy, việc phân trang hoặc split xảy ra thường hơn. Redo log và chi phí duy trì index cũng tăng.
