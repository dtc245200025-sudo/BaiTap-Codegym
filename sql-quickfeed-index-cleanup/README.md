# Tối ưu Index cho QuickFeed

Bài làm CodeGym 397. Chạy `quickfeed_index_optimization.sql` bằng MySQL 8 để:

1. Tạo 10.000 bài viết và năm index của hệ thống cũ.
2. Đo dung lượng Data/Index trước khi tối ưu.
3. Xóa đúng `idx_content`, `idx_post_type`, `idx_is_visible`.
4. Giữ `idx_user_id`, `idx_created_at`.
5. Đo lại và tự tính số MB index được giải phóng.

File ZIP chứa ba sản phẩm chính theo yêu cầu nộp bài.
