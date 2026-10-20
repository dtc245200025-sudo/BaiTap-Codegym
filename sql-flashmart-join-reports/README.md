# FlashMart JOIN Reports

Bài nộp cho hoạt động **[Thực hành] Khủng Hoảng Chiến Dịch Marketing Tại FlashMart**.

## Tệp bài làm

- `flashmart_reports.sql`: tạo dữ liệu mẫu và hai báo cáo đã sửa bằng `LEFT JOIN`.
- `join_analysis.md`: giải trình ngắn về lựa chọn JOIN và `COUNT(o.order_id)`.
- `ai_prompt_log.md`: nhật ký hỏi đáp lý thuyết JOIN với AI.
- `flashmart-join-practice.zip`: bản đóng gói ba tệp cần nộp.

## Cách chạy

Mở `flashmart_reports.sql` trong MySQL Workbench và chạy toàn bộ script.

## Kết quả cần đối chiếu

Báo cáo Marketing phải trả đúng ba dòng:

| customer_id | name | total_orders |
| ---: | --- | ---: |
| 1 | Alice | 2 |
| 2 | Bob | 1 |
| 3 | Charlie | 0 |

Báo cáo Kho vận phải trả đúng một dòng:

| product_id | product_name |
| ---: | --- |
| 103 | Keyboard |
