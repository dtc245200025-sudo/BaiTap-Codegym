# Thực hành truy vấn CSDL quản lý sinh viên

Bài nộp cho hoạt động **[Thực hành] Truy vấn dữ liệu với CSDL Quản lý sinh viên**.

Tệp [`queries.sql`](queries.sql) gồm đủ năm yêu cầu:

1. Danh sách tất cả học viên.
2. Danh sách học viên đang theo học (`Status = 1`).
3. Danh sách môn học có `Credit < 10`.
4. Danh sách học viên thuộc lớp `A1` bằng phép `JOIN` giữa `Student` và `Class`.
5. Điểm môn `CF` bằng phép `JOIN` giữa `Student`, `Mark` và `Subject`.

## Cách chạy

1. Tạo cấu trúc và dữ liệu `QuanLySinhVien` theo hai bài thực hành trước.
2. Mở MySQL Workbench và kết nối tới MySQL Server.
3. Mở `queries.sql`, sau đó chạy toàn bộ hoặc chạy từng câu `SELECT`.

## Kết quả dự kiến với dữ liệu mẫu

- Có 3 học viên: Hung, Hoa và Manh.
- Hung và Hoa đang theo học.
- Các môn có tín chỉ nhỏ hơn 10: CF, C và HDJ.
- Lớp A1 có Hung và Hoa.
- Điểm môn CF: Hung được 8 điểm; Hoa được 10 điểm.

Các truy vấn dùng tên cột rõ ràng, bí danh bảng và `ORDER BY` để kết quả ổn định, dễ kiểm tra.
