# Phân tích lựa chọn JOIN

`LEFT JOIN` giữ toàn bộ dòng của bảng bên trái, kể cả khi bảng bên phải không có bản ghi khớp. Vì vậy, báo cáo Marketing đặt `Customers` bên trái để Charlie vẫn xuất hiện với dữ liệu đơn hàng là `NULL`.

Truy vấn dùng `COUNT(o.order_id)` thay cho `COUNT(*)`. Với Charlie, `LEFT JOIN` vẫn tạo một dòng kết quả nhưng `o.order_id` là `NULL`. `COUNT(*)` sẽ đếm dòng đó và trả 1 sai lệch; `COUNT(o.order_id)` bỏ qua `NULL` nên trả đúng 0.

Báo cáo Kho vận đặt `Products` bên trái, sau đó lọc `o.order_id IS NULL`. Đây là anti-join: chỉ giữ sản phẩm không có đơn hàng tương ứng, vì vậy kết quả là Keyboard. Nếu dùng `INNER JOIN`, các dòng không khớp bị loại trước khi mệnh đề `WHERE` chạy nên không thể tìm được sản phẩm chưa bán.
