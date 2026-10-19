# HealthSync — Báo cáo nhất quán nghiệp vụ và dữ liệu

**1. Vòng đời bị rút gọn.** `is_active` không phân biệt chờ duyệt, xác nhận cọc, tiếp nhận, hoàn tất và hủy. Backend vì vậy không xác định được khi nào được khám hoặc kê đơn. Thay bằng `status ENUM` gồm năm trạng thái; trigger kiểm soát chuyển trạng thái. Luồng thành công bổ sung `CONFIRMED` trước `CHECKED_IN`, đúng mô tả nghiệp vụ.

**2. Thiếu căn cứ đối soát.** Thiết kế cũ thiếu cả tiền cọc, phí phạt và lý do hủy. Kế toán không thể xác định khoản giữ lại hay phải hoàn. Bổ sung `deposit_amount`, `penalty_fee` kiểu `DECIMAL(12,2)` và `cancel_reason`; ràng buộc cọc dương, phí không vượt cọc, hủy phải có lý do. Cọc 300.000đ, phạt 150.000đ thì phải hoàn 150.000đ; không ghi đè cọc gốc.

**3. Không có nơi lưu đơn thuốc.** Tạo `Prescriptions` với khóa ngoại đến lịch hẹn và `UNIQUE(appointment_id)`, biểu diễn tối đa một đơn mỗi lịch. Trigger chặn kê đơn khi chưa `COMPLETED`; `RESTRICT` bảo vệ liên kết hồ sơ. Hoàn tất khám và tạo đơn nằm cùng giao dịch. Các ràng buộc giúp BA và Dev thống nhất điều kiện nghiệp vụ, tránh triển khai sai Activity Diagram.
