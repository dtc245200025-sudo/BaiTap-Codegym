# Phân tích EXPLAIN

Truy vấn cũ bọc `created_at` trong `YEAR()` và `MONTH()`, nên MySQL phải tính hàm cho từng dòng. Đây là điều kiện Non-SARGable: `type` thường là `ALL`, `key` để trống và `rows` xấp xỉ toàn bộ bảng.

Index `idx_type_date(transaction_type, created_at)` đặt cột so sánh bằng trước và cột lọc khoảng sau. Khi đổi điều kiện ngày thành khoảng nửa kín từ `2026-06-01` đến trước `2026-07-01`, MySQL có thể dò trực tiếp trên B-Tree. Kế hoạch mới dự kiến có `type = range`, `possible_keys` và `key` cùng hiển thị `idx_type_date`; `rows` chỉ còn số giao dịch nạp trong tháng 6 thay vì toàn bộ bảng.

Khoảng nửa kín cũng xử lý đúng mọi thời điểm trong ngày cuối tháng, không phụ thuộc phần giây của `DATETIME`. Số `rows` cụ thể thay đổi theo dữ liệu và thống kê của máy chủ, nhưng kế hoạch mới phải loại bỏ Full Table Scan.
