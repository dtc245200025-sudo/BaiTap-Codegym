# Đối chiếu Activity Diagram và ERD AutoRide

Activity Diagram yêu cầu khấu trừ chi phí hư hỏng trước khi hoàn cọc. Nếu thiếu `damage_fee`, hệ thống không lưu được số tiền bồi thường, dù biên bản đã mô tả lỗi. Kế toán có thể hoàn thừa cọc và không đối soát được khoản giữ lại.

Vì vậy, `Rentals` cần `security_deposit`, `late_fee`, `damage_fee` kiểu `DECIMAL`, không nhận `NULL`, phí mặc định bằng 0 và không âm. Tiền còn lại bằng cọc trừ hai khoản phí. Cọc 10.000.000đ, không trễ, sửa đèn 2.000.000đ thì phải hoàn 8.000.000đ.

`Inspections` lưu bằng chứng kiểm tra qua khóa ngoại `rental_id`. Trigger chỉ cho ghi biên bản khi `ACTIVE`; trước `COMPLETED` phải có biên bản trả xe, có mô tả nếu tính phí hư hỏng. `due_date` và `return_date` phân biệt hạn trả với thời điểm trả thật. Các dữ liệu này nối nhánh kiểm tra, tính phí và hoàn cọc của quy trình với cấu trúc lưu trữ.
