# Trigger trong MySQL

Bài làm CodeGym 396. Script tạo CSDL `company`, bảng `employees` và trigger `update_department` chạy trước mỗi lần thêm nhân viên.

Quy tắc tự động:

- Lương từ 5.000: `Management`.
- Lương từ 3.000 đến dưới 5.000: `Sales`.
- Lương dưới 3.000: `Support`.

Ba dòng dữ liệu cuối script kiểm chứng đủ cả ba nhánh điều kiện và `SHOW TRIGGERS` xác nhận trigger đã được tạo.
