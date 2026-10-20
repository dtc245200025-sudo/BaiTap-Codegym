# Bài tập truy vấn CSDL quản lý sinh viên

Bài nộp cho hoạt động **[Bài tập] Truy vấn dữ liệu với CSDL Quản lý sinh viên**.

Tệp [`queries.sql`](queries.sql) giải quyết đủ năm yêu cầu:

1. Dùng `LIKE 'H%'` để tìm sinh viên có tên bắt đầu bằng H.
2. Dùng `MONTH(StartDate) = 12` để lọc lớp bắt đầu trong tháng 12.
3. Dùng `BETWEEN 3 AND 5` để lọc môn học theo credit.
4. Dùng `UPDATE` trong transaction để chuyển Hung sang lớp có `ClassID = 2`.
5. JOIN `Student`, `Mark`, `Subject`, sau đó sắp xếp `Mark DESC` và `StudentName ASC`.

## Cách chạy

1. Chuẩn bị cơ sở dữ liệu `QuanLySinhVien` và dữ liệu mẫu từ các bài trước.
2. Mở `queries.sql` bằng MySQL Workbench.
3. Chạy lần lượt từng khối truy vấn để quan sát kết quả.

Sau câu lệnh cập nhật, truy vấn kiểm tra phải cho thấy sinh viên Hung có `ClassID = 2`.

Với dữ liệu mẫu ban đầu, truy vấn cuối sắp xếp điểm theo thứ tự: Hung/C (12), Hoa/CF (10), Hung/CF (8).
