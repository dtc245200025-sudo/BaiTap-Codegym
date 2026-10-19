# HealthSync — Nhật ký sử dụng AI

**Ngày:** 19/10/2026. **Công cụ:** Codex. **Phạm vi:** hỗ trợ chuẩn bị ba tệp theo đề đính kèm.

## 1. Trao đổi thực tế

**Yêu cầu của người học:** “giúp tôi tạo các file cần nộp”, kèm toàn bộ nội dung đề HealthSync.

**Phản hồi và hỗ trợ của AI:** xác định ba tệp cần nộp; đề xuất thiết kế trạng thái, các cột tài chính, bảng đơn thuốc và trigger; soạn SQL, báo cáo và nhật ký; tìm tài liệu MySQL chính thức và kiểm thử bằng một MySQL riêng trong thư mục làm việc.

Đây là bản ghi của một yêu cầu tổng hợp thực tế. Những chủ đề dưới đây là nội dung AI đã rà soát trong lần hỗ trợ này, **không phải các lượt hỏi đáp riêng do người học thực hiện**.

## 2. Nội dung kỹ thuật AI đã hỗ trợ

| Chủ đề | Kết luận và cách áp dụng |
| --- | --- |
| Boolean và vòng đời | `is_active` không diễn đạt đủ năm trạng thái. `ENUM` giới hạn tập giá trị; trigger mới kiểm soát thứ tự chuyển trạng thái. |
| `FLOAT`, `DOUBLE`, `DECIMAL` | Hai kiểu đầu dùng số gần đúng. Chọn `DECIMAL(12,2)` để biểu diễn tiền theo độ chính xác thập phân đã khai báo; vẫn cần chính sách làm tròn nếu đầu vào có hơn hai chữ số lẻ. |
| Tái cấu trúc | Dùng `ALTER TABLE` trên bảng legacy rỗng để bỏ `is_active` và thêm cột. Với dữ liệu thật, không tự suy trạng thái, cọc hoặc phí từ Boolean; cần sao lưu và đối chiếu lịch sử trước khi chuyển đổi. |
| Khóa ngoại và số lượng đơn | FK bảo đảm lịch hẹn tồn tại; `NOT NULL` ngăn đơn không có lịch; `UNIQUE(appointment_id)` giới hạn một đơn mỗi lịch. FK không kiểm tra được lịch đã khám xong. |
| `CASCADE` hay `RESTRICT` | Chọn `RESTRICT` để việc xóa lịch có đơn bị từ chối, bảo vệ liên kết hồ sơ. `CASCADE` thích hợp khi bản ghi con được phép xóa theo cha; không chọn mặc định cho đơn thuốc. |
| Trigger và trạng thái | Dùng `BEFORE INSERT`/`BEFORE UPDATE`, đọc trạng thái lịch hẹn và `SIGNAL SQLSTATE '45000'` nếu chưa `COMPLETED`. Trigger trên lịch hẹn chặn chuyển trạng thái sai hoặc quay lại sau trạng thái cuối. |
| Dòng tiền | Giữ tiền cọc ban đầu, lưu phí phạt riêng. `deposit_amount - penalty_fee` của lịch hủy là số **phải hoàn**, chưa chứng minh tiền đã được hoàn và chưa phải sổ kế toán đầy đủ. |

## 3. Các giả định được công khai

- Mỗi lịch hẹn có tối đa một đơn. Trước khi hoàn tất, quan hệ thực tế là `Appointments 1 — 0..1 Prescriptions`.
- Có thể hủy khi `PENDING`, `CONFIRMED` hoặc `CHECKED_IN`; hủy trước xác nhận không phạt. Đây là quy ước thiết kế cho phần đề chưa mô tả hết.
- Mức 150.000đ chỉ áp dụng cho kịch bản mẫu; đề không quy định công thức phạt chung. SQL kiểm tra giới hạn phí, không tự suy ra chính sách 50%.
- Kịch bản thành công đi qua `CONFIRMED` trước `CHECKED_IN`, bổ sung bước bị lược trong ví dụ DML của đề.
- FK và UNIQUE chỉ bảo đảm tối đa một đơn. Giao dịch mẫu tạo đơn cùng lúc hoàn tất khám; thiết kế chưa cưỡng chế “mọi lịch COMPLETED luôn có đơn” đối với client tùy ý ghi trực tiếp. Muốn cưỡng chế tuyệt đối cần procedure hoàn tất khám và phân quyền chỉ cho phép gọi procedure.
- Script chạy một lần trên database chưa có các bảng HealthSync; không tự xóa bảng và không phải migration dữ liệu lịch sử.

## 4. Kiểm chứng

Đã chạy bản SQL cuối cùng trên **MySQL Community Server 8.0.45**, bằng instance riêng có thư mục dữ liệu trong `work/mysql-data`; không kết nối database đang sử dụng của người học. Instance thử nghiệm đã được tắt sau khi kiểm tra.

Lần chạy đầu phát hiện lỗi MySQL **1832** khi đổi cột đang có FK sang `NOT NULL`. AI đã sửa bằng cách gỡ hai FK trước `ALTER`, rồi tạo lại đầy đủ sau khi thay đổi cột. Bản sửa đã được chạy lại từ database thử nghiệm trống.

**Kết quả thực tế:** script không còn lỗi; hai kịch bản chính đều trả `PASS`. Ngoài ra đã xác nhận 21 trường hợp sai bị từ chối đúng mã lỗi dự kiến, ba thao tác hợp lệ bổ sung chạy được và cấu trúc/dữ liệu cuối đúng yêu cầu: tổng cộng **26 nhóm kiểm tra đạt** (hai kịch bản chính được tính chung một nhóm).

| Dữ liệu sau khi chạy | Trạng thái | Tiền cọc | Phí phạt | Phải hoàn do hủy | Số đơn |
| --- | --- | ---: | ---: | ---: | ---: |
| Nguyễn Minh An | `COMPLETED` | 500.000đ | 0đ | Không áp dụng | 1 |
| Trần Thu Bình | `CANCELLED` | 300.000đ | 150.000đ | 150.000đ | 0 |

- Các kiểm thử bị chặn gồm: kê đơn cho lịch `PENDING`/`CANCELLED`/không tồn tại; đơn trùng; tiền cọc không dương; phí âm hoặc vượt cọc; thiếu lý do hủy; chuyển trạng thái sai; chuyển đơn sang lịch khác; xóa lịch có đơn; xóa bệnh nhân có lịch; đơn rỗng; bệnh nhân không tồn tại hoặc `NULL`.
- Kiểm thử hợp lệ bổ sung: hủy `PENDING` không phạt, hủy `CONFIRMED` có phạt và sửa nội dung đơn hợp lệ.
- Kiểm tra cuối: không còn cột `is_active`, có bốn trigger; còn đúng hai bệnh nhân, một bác sĩ, hai lịch và một đơn. Dữ liệu thử bổ sung đã được rollback.

Các phần `SELECT` và sáu ví dụ kiểm thử âm có sẵn trong `healthsync_db.sql` để người học chạy lại và tự giải thích. Truy vấn tìm lịch hoàn tất thiếu đơn hoặc lịch chưa hoàn tất có đơn trả về không có dòng vi phạm sau hai kịch bản mẫu.

## 5. Ghi chú về quy định sử dụng AI của đề

Đề giới hạn AI ở thảo luận mô hình, cú pháp và hỗ trợ từng vấn đề, đồng thời cấm giao toàn bộ yêu cầu để AI viết toàn bộ SQL. Lần hỗ trợ này đã nhận toàn bộ đề và soạn bộ tệp tổng hợp, nên **vượt phạm vi sử dụng AI được mô tả trong đề**. Nhật ký công khai điều này, không dựng các prompt nhỏ để làm như người học đã tự triển khai từng bước. Người học cần tự thực hiện, kiểm chứng và trao đổi với giảng viên về phần hỗ trợ được chấp nhận trước khi dùng làm bài nộp.

## 6. Tài liệu đã đối chiếu

- [MySQL 8.0 — CHECK constraints](https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html): ràng buộc miền giá trị; yêu cầu MySQL từ 8.0.16.
- [MySQL 8.4 — Kiểu số chính xác và gần đúng](https://dev.mysql.com/doc/refman/8.4/en/precision-math-numbers.html): căn cứ chọn `DECIMAL` cho tiền.
- [MySQL 8.4 — Foreign keys](https://dev.mysql.com/doc/refman/8.4/en/create-table-foreign-keys.html): liên kết bảng, chỉ mục và hành vi `RESTRICT`/`CASCADE`.
- [MySQL 8.4 — CREATE TRIGGER](https://dev.mysql.com/doc/refman/8.4/en/create-trigger.html): cú pháp trigger và tham chiếu `OLD`/`NEW`.
