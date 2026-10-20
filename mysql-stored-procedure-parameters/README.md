# Truyền tham số vào Stored Procedure

Bài làm CodeGym 394 trên cơ sở dữ liệu `classicmodels`.

Script minh họa đủ ba loại tham số:

- `getCusById`: nhận `IN` để tìm khách hàng theo mã.
- `GetCustomersCountByCity`: nhận thành phố qua `IN` và trả số khách qua `OUT`.
- `SetCounter`: nhận và cập nhật bộ đếm qua `INOUT`.

Cuối file có lời gọi kiểm thử; giá trị cuối của `@counter` là `8`.
