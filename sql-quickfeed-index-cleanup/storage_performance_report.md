# Báo cáo Storage và Performance

QuickFeed ban đầu có năm secondary index. Script đo `data_length` và `index_length` trên 10.000 bài viết, lưu số MB thật vào `StorageAudit`, rồi in bảng `data_mb_before`, `index_mb_before`, `data_mb_after`, `index_mb_after` và `index_mb_released`. Kết quả cụ thể phụ thuộc phiên bản MySQL, page size và cách InnoDB cấp phát extent; vì vậy dùng số đo do máy chủ trả về thay vì ước lượng cố định.

`idx_content` rất lớn vì lưu tiền tố 255 ký tự cho mọi bài. Tìm kiếm từ trong nội dung nên dùng FULLTEXT. `idx_post_type` chỉ phân biệt ba loại và `idx_is_visible` chỉ phân biệt hai trạng thái; với phân bố 99% visible, optimizer thường quét bảng vì index không loại được đủ dòng. Hai index được giữ là `idx_user_id`, phục vụ trang cá nhân, và `idx_created_at`, phục vụ newsfeed theo thời gian.

Sau dọn dẹp, số secondary index giảm từ 5 xuống 2. Mỗi lần INSERT không còn phải cập nhật ba cây B-Tree dư thừa, nên giảm I/O, CPU, page split và lock contention. Đổi lại, các truy vấn hiếm lọc riêng theo `post_type` hoặc `is_visible` có thể quét nhiều dòng hơn. Đây là đánh đổi phù hợp vì tốc độ ghi là yêu cầu chính và hai cột đó có cardinality thấp.
