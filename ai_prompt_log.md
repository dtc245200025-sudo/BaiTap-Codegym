# AutoRide — Nhật ký hỗ trợ AI

**Ngày:** 19/10/2026. **Công cụ:** Codex.

## 1. Trao đổi thực tế và phạm vi

Người học gửi toàn bộ đề AutoRide cùng yêu cầu: “với mỗi câu hỏi, hãy tạo 1 thư mục để lưu file trả lời;”. Trợ lý hiểu mỗi bài được gửi là một câu hỏi, tạo thư mục `AutoRide` và soạn bộ trả lời theo ba đầu mục của đề. Không có các lượt hỏi đáp kỹ thuật riêng do người học nhập trong bài này; những mục bên dưới là nội dung trợ lý tự phân tích, không phải lịch sử prompt giả lập.

Đề giới hạn AI ở hỗ trợ kỹ thuật từng vấn đề và cấm giao toàn bộ đề cho AI viết script. Bộ tệp này được AI hỗ trợ soạn tổng hợp, vượt phạm vi đó. Người học cần tự thực hiện, giải thích thiết kế và xác nhận với giảng viên phạm vi hỗ trợ được chấp nhận trước khi nộp. Nhật ký không được dùng để khẳng định người học đã tự viết hoặc tự kiểm thử.

## 2. Chẩn đoán các khoảng trống dữ liệu

| Khoảng trống | Hậu quả | Điều chỉnh |
| --- | --- | --- |
| Không có tiền cọc | Không có căn cứ đối chiếu tiền đã nhận | Thêm `security_deposit` |
| Không có phạt trễ | Không lưu được khoản khấu trừ do trễ hạn | Thêm `late_fee` |
| Không có phí hư hỏng | Hoàn thừa cọc hoặc theo dõi trên giấy | Thêm `damage_fee` |
| Không có biên bản | Thiếu mô tả, người kiểm tra và thời gian kiểm tra | Tạo `Inspections` |
| Không phân biệt hạn trả và ngày trả thực tế | Không xác định được thời gian trễ | Giữ `return_date` là thực tế, thêm `due_date` |
| Trạng thái không có miền giá trị, thứ tự chuyển chưa được kiểm soát | Nhập sai hoặc hoàn tất trước kiểm tra | `ENUM`, CHECK và trigger |

`VARCHAR` không tự nó là thiết kế sai: có thể kết hợp CHECK hoặc bảng tra cứu để kiểm soát miền giá trị. Ở bản legacy, vấn đề là thiếu ràng buộc; bản sửa dùng ENUM đúng yêu cầu bài.

## 3. Các vấn đề kỹ thuật được trợ lý phân tích

**Tiền và NULL.** Chọn `DECIMAL(12,2)` thay cho FLOAT/DOUBLE. Cọc bắt buộc dương; hai khoản phí không âm, `NOT NULL DEFAULT 0.00`. Vì vậy phép trừ không bị biến thành NULL. Khi xử lý nguồn dữ liệu cũ có NULL, chỉ dùng `COALESCE(fee,0)` nếu đã xác nhận NULL thực sự có nghĩa là không thu phí; không biến khoản cọc chưa biết thành 0 để che thiếu dữ liệu. DECIMAL vẫn cần chính sách làm tròn nếu dữ liệu đầu vào có nhiều chữ số lẻ hơn độ chính xác đã khai báo.

**1–1 hay 1–N.** Nếu mỗi hợp đồng chỉ có đúng một biên bản, có thể thêm `UNIQUE(rental_id)` vào `Inspections`. Bản này chọn 1–N để cho phép nhiều lần kiểm tra trong lúc hợp đồng ACTIVE. Mỗi biên bản có ngày, người kiểm tra và mô tả riêng; tách bảng giúp lưu từng sự kiện. Chỉ riêng việc đặt một mô tả trong Rentals không mặc nhiên vi phạm 3NF nếu thật sự chỉ có một mô tả cho mỗi hợp đồng; lựa chọn phụ thuộc số lượng và vòng đời của biên bản. Phí tổng hợp vẫn lưu một lần trong Rentals; không cộng lại phí sau JOIN nhiều biên bản.

**Ngăn kiểm tra khi BOOKED.** FK chỉ bảo đảm hợp đồng tồn tại. Trigger `BEFORE INSERT` trên Inspections đọc trạng thái hợp đồng với `FOR SHARE`, rồi phát `SIGNAL SQLSTATE '45000'` nếu không ACTIVE. Trigger UPDATE ngăn đổi biên bản sang hợp đồng khác và sửa sau khi hoàn tất. Trigger DELETE ngăn xóa biên bản của hợp đồng COMPLETED.

**Hoàn tất hợp đồng.** Trigger chặn chuyển BOOKED thẳng sang COMPLETED, chặn hoàn tất khi chưa có biên bản trả xe và yêu cầu mô tả nếu `damage_fee > 0`. Biên bản trả xe có thời gian không trước `return_date`. Biên bản được ghi trước khi cập nhật COMPLETED trong cùng giao dịch; lỗi phải ROLLBACK. Hợp đồng ở trạng thái cuối không được sửa bằng luồng thông thường. Quy trình điều chỉnh sai sót sau chốt sổ cần thiết kế riêng nếu phát sinh.

**Toàn vẹn và trải nghiệm.** Khi UML có bước tính phí mà ERD thiếu nơi lưu, màn hình không ghi được khoản thu, nhân viên phải nhập lại ngoài hệ thống, số tiền hoàn sai và khách khó kiểm tra căn cứ khấu trừ. Mỗi nhánh nghiệp vụ phải có dữ liệu và ràng buộc tương ứng.

## 4. Các giả định và giới hạn công khai

- Script dùng CREATE cho cấu trúc legacy rỗng rồi ALTER; chạy một lần trên database chưa có các bảng cùng tên. Đây không phải migration tự động cho dữ liệu đang vận hành. Dữ liệu thật cần backup, làm sạch trạng thái và đối chiếu số tiền, hạn trả trước khi siết NOT NULL.
- `BOOKED → ACTIVE → COMPLETED`; chỉ cho hủy từ BOOKED vì đề chưa xác định chính sách hủy sau nhận xe. Không tự thu phí hủy.
- Cọc là khoản được ghi nhận theo bài tập; script không tích hợp thanh toán và không xác minh giao dịch ngân hàng. `refund_due` là số phải hoàn, chưa chứng minh đã chuyển tiền.
- Ca bắt buộc dùng phí trễ 0 và phí hỏng 2.000.000đ. Ca thêm trả trễ hai ngày giả định 500.000đ/ngày, làm tròn lên phần ngày; đây là chính sách minh họa, không phải quy định của đề.
- Nếu phí vượt cọc, số dư cọc có thể âm; hiển thị tiền hoàn tối thiểu 0 và khoản phải thu thêm riêng, không hoàn tiền âm.
- Giữ tên khách trong Rentals theo cấu trúc đề. Chưa mở rộng danh mục khách hàng, lịch sử thanh toán hoặc chống đặt trùng xe.

## 5. Kết quả kiểm thử

Đã chạy thực tế bằng **MySQL Community Server 8.0.45**, dùng instance riêng có dữ liệu trong `work/mysql-data`, không kết nối database đang sử dụng của người học. Instance đã được tắt sau kiểm thử.

| Kịch bản | Cọc | Phạt trễ | Phí hỏng | Phải hoàn |
| --- | ---: | ---: | ---: | ---: |
| Nguyen Van A, vỡ đèn pha trái, trả đúng hạn | 10.000.000đ | 0đ | 2.000.000đ | **8.000.000đ** |
| Nguyen Van C, trễ hai ngày, vỡ đèn pha trái | 10.000.000đ | 1.000.000đ | 2.000.000đ | **7.000.000đ** |

Hai hợp đồng đều ở trạng thái `COMPLETED`; kịch bản bắt buộc trả `PASS`. Kiểm tra cấu trúc/dữ liệu cuối ghi nhận một xe, hai hợp đồng, hai biên bản và năm trigger.

**24 trường hợp sai đã bị từ chối đúng mã lỗi dự kiến:** chèn biên bản khi BOOKED hoặc sau COMPLETED; hợp đồng không tồn tại; hoàn tất thiếu biên bản, thiếu mô tả hư hỏng hoặc chỉ có biên bản trước thời điểm trả; thu phí trễ khi trả đúng hạn; tiền âm hoặc NULL; hạn trả trước ngày thuê; xe không tồn tại; xóa xe/hợp đồng đang được tham chiếu; sửa/xóa biên bản đã chốt; sửa hợp đồng đã chốt; kiểm tra trước ngày thuê; bỏ trống tên nhân viên; chuyển biên bản sang hợp đồng khác; hủy từ ACTIVE; bỏ qua bước ACTIVE.

**Bốn trường hợp hợp lệ bổ sung đã chạy được:** nhiều biên bản cho một hợp đồng; hoàn tất không có hư hỏng; phí hỏng vượt cọc; hủy từ BOOKED. Khi phí 12.000.000đ vượt cọc 10.000.000đ, truy vấn hiển thị hoàn 0đ, phải thu thêm 2.000.000đ. Các dữ liệu kiểm thử bổ sung được rollback, không lẫn vào hai kịch bản chính.

## 6. Tài liệu tham khảo

- [MySQL — CHECK constraints](https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html).
- [MySQL — CREATE TRIGGER](https://dev.mysql.com/doc/refman/8.4/en/create-trigger.html).
- [MySQL — Foreign keys và RESTRICT](https://dev.mysql.com/doc/refman/8.4/en/create-table-foreign-keys.html).
- [MySQL — Kiểu số chính xác và gần đúng](https://dev.mysql.com/doc/refman/8.4/en/precision-math-numbers.html).

Các tài liệu này đã được tra cứu trong chuỗi trao đổi trước; cú pháp bản AutoRide được kiểm tra thêm bằng máy chủ MySQL thực tế như ghi ở mục 5.
