# Tối ưu báo cáo PayFlow

Bài làm cho hoạt động CodeGym 375, gồm truy vấn cũ, composite index, truy vấn SARGable và hai báo cáo giải trình theo đúng định dạng nộp bài.

## Cách chạy

1. Mở `payflow_optimized.sql` bằng MySQL Workbench (MySQL 8.0.18 trở lên).
2. Chạy toàn bộ script. Script tạo 100.000 dòng dữ liệu minh họa để kế hoạch thực thi có ý nghĩa.
3. So sánh hai Result Grid của `EXPLAIN`: truy vấn mới phải dùng `idx_type_date` và giảm số dòng ước tính cần đọc.
4. Xem kết quả `EXPLAIN ANALYZE` cuối file để so sánh số dòng và thời gian thực tế.

File `payflow-index-optimization.zip` chứa ba sản phẩm chính theo yêu cầu nộp bài.
