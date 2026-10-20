# Báo cáo đánh đổi Index

`idx_fat_covering` chứa năm cột nên Dashboard đọc kết quả ngay trên secondary index và EXPLAIN có thể báo `Using index`. Đổi lại, mỗi entry phải giữ hai cột tìm kiếm, ba cột kết quả và khóa chính `log_id`. Script đo `index_length` trước và sau chuyển đổi để lấy số MB thực tế.

SmartFactory ghi hàng chục nghìn mẫu mỗi giây. Mỗi INSERT phải tạo entry dài, ghi redo log và có thể tách page. Nhiệt độ, độ ẩm và trạng thái không giúp thu hẹp điều kiện tìm kiếm. Chi phí lưu trữ, RAM và I/O vì thế vượt quá thời gian SELECT tiết kiệm được.

`idx_lean_search(sensor_id, recorded_at)` giữ đúng hai cột trong `WHERE`. EXPLAIN sau tối ưu phải chọn index này với `type` là `range` hoặc `ref`. `Extra` không còn `Using index` vì MySQL cần quay lại clustered index để lấy dữ liệu hiển thị. Lookup bổ sung làm SELECT chậm nhẹ, nhưng index nhỏ hơn giúp INSERT nhanh hơn, giảm dung lượng SSD và giữ nhiều page hữu ích trong RAM. Đây là lựa chọn phù hợp với hệ thống IoT ưu tiên ghi liên tục.
