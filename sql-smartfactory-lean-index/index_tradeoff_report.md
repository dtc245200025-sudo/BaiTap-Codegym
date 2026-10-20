# Báo cáo đánh đổi Index

`idx_fat_covering` chứa năm cột nên Dashboard đọc `temperature`, `humidity`, `status` ngay trên secondary index và EXPLAIN có thể báo `Using index`. Lợi ích đọc này phải trả bằng một cây B-Tree lớn: mỗi entry giữ hai cột tìm kiếm, ba cột kết quả và khóa chính `log_id`. Với 100.000 dòng thử nghiệm, script đọc `index_length` từ `information_schema.TABLES` trước và sau chuyển đổi để cung cấp số MB thực tế của máy chủ.

SmartFactory ghi hàng chục nghìn mẫu mỗi giây. Mỗi INSERT phải tạo entry dài, ghi redo log và có thể tách page của fat index. Cột nhiệt độ, độ ẩm và trạng thái thay đổi ở mọi mẫu nhưng không giúp thu hẹp điều kiện tìm kiếm. Chi phí lưu trữ, buffer pool và I/O vì thế vượt quá phần thời gian SELECT tiết kiệm được.

`idx_lean_search(sensor_id, recorded_at)` giữ đúng hai cột trong `WHERE`. EXPLAIN sau tối ưu phải chọn `idx_lean_search` với `type` là `range` hoặc `ref`. `Extra` không còn `Using index` vì MySQL cần quay lại clustered index để lấy ba cột hiển thị. Một lần lookup bổ sung làm SELECT chậm nhẹ, nhưng index nhỏ hơn giúp INSERT nhanh hơn, giảm dung lượng SSD và cho phép nhiều page hữu ích nằm trong RAM. Đây là lựa chọn phù hợp với hệ thống IoT ưu tiên luồng ghi liên tục.
