# Thực hành thêm dữ liệu vào CSDL quản lý sinh viên

Bài nộp cho hoạt động **[Thực hành] Thêm dữ liệu vào trong cơ sở dữ liệu quản lý sinh viên**.

## Nội dung

- `01-schema.sql`: tạo cơ sở dữ liệu `QuanLySinhVien` và bốn bảng theo bài thực hành trước.
- `02-insert-data.sql`: thêm đầy đủ dữ liệu vào `Class`, `Student`, `Subject` và `Mark`.
- `03-check-data.sql`: truy vấn từng bảng và truy vấn tổng hợp để kiểm tra kết quả.

## Cách chạy

Mở MySQL Workbench, kết nối tới MySQL Server và chạy các tệp theo thứ tự:

1. `01-schema.sql`
2. `02-insert-data.sql`
3. `03-check-data.sql`

Nên chạy trên cơ sở dữ liệu mới hoặc các bảng đang trống. Các mã định danh được ghi rõ để dữ liệu liên kết đúng với đề bài.

## Kết quả mong đợi

| Bảng | Số bản ghi |
| --- | ---: |
| `Class` | 3 |
| `Student` | 3 |
| `Subject` | 4 |
| `Mark` | 3 |

Dữ liệu của sinh viên `Hoa` không có số điện thoại nên giá trị `Phone` được lưu là `NULL`.
