# Chỉ mục trong MySQL

Bài làm CodeGym 392 trên cơ sở dữ liệu mẫu `classicmodels`.

Script `index_practice.sql` dùng `EXPLAIN` để so sánh kế hoạch trước và sau khi tạo `idx_customerName`, thực hành composite index `idx_full_name`, minh họa quy tắc tiền tố trái và xóa index thử nghiệm khi hoàn tất.

Khi chạy trên dữ liệu đủ lớn, truy vấn `customerName` trước khi tạo index thường có `type = ALL`; sau khi tạo index, `possible_keys` và `key` hiển thị `idx_customerName`, số dòng ước tính giảm mạnh.
