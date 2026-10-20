# Thao tác với CSDL Quản lý bán hàng

Bài làm cho hoạt động CodeGym 374. Script `sales_management.sql` thực hiện đầy đủ:

1. Tạo cơ sở dữ liệu `QuanLyBanHang` và bốn bảng có khóa chính, khóa ngoại.
2. Thêm toàn bộ dữ liệu mẫu trong đề bài.
3. Liệt kê hóa đơn và tổng tiền đang lưu.
4. Liệt kê khách hàng đã mua hàng cùng các sản phẩm tương ứng.
5. Tìm khách hàng chưa từng mua hàng bằng `LEFT JOIN`.
6. Tính giá từng hóa đơn bằng `SUM(odQTY * pPrice)` và cập nhật `oTotalPrice`.

## Kết quả tổng tiền mong đợi

| oID | oDate | oPrice |
| ---: | :--- | ---: |
| 1 | 2006-03-21 | 60 |
| 2 | 2006-03-23 | 30 |
| 3 | 2006-03-16 | 24 |

Khách hàng không mua sản phẩm nào là `Hong Ha` (cID = 3).

## Cách chạy

Mở MySQL Workbench, mở file `sales_management.sql`, sau đó chạy toàn bộ script theo thứ tự từ trên xuống.
