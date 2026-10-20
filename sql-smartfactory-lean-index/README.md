# SmartFactory Lean Index

Bài làm CodeGym 399. Script tạo 100.000 bản ghi cảm biến, đo fat index, chạy EXPLAIN, thay bằng lean index rồi đo và chạy EXPLAIN lại.

Bộ nộp gồm:

- `smartfactory_reindex.sql`
- `index_tradeoff_report.md` (khoảng 200 từ)
- `ai_prompt_log.md`
- `smartfactory-lean-index.zip`

Số MB phụ thuộc cấu hình InnoDB; script truy vấn trực tiếp `information_schema.TABLES` để kết quả nộp phản ánh đúng môi trường chạy.
