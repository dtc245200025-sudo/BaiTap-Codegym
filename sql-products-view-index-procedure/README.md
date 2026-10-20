# View, Index, Stored Procedure

Bài làm CodeGym 398. `products_database.sql` là script độc lập và có thể chạy lại từ đầu.

Nội dung gồm:

- CSDL `product_management`, bảng `Products` và năm sản phẩm mẫu.
- `EXPLAIN` trước/sau unique index `productCode` và composite index `(productName, productPrice)`.
- Tạo, truy vấn, sửa và xóa `product_view`.
- Bốn procedure: xem tất cả, thêm, sửa và xóa sản phẩm.
- Kịch bản gọi thử procedure trong transaction; `ROLLBACK` giữ bộ dữ liệu mẫu nguyên vẹn.

Chạy toàn bộ file bằng MySQL Workbench 8.0 để xem từng Result Grid và kế hoạch thực thi.
