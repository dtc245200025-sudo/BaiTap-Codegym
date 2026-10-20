# Nhật ký trao đổi với AI

## 1. Vì sao `YEAR(created_at)` làm mất tác dụng của Index?

**Câu hỏi:** Khi bọc một cột ngày bằng `YEAR()` và `MONTH()`, vì sao MySQL thường quét toàn bảng?

**Tóm tắt trả lời:** B-Tree lưu giá trị gốc của `created_at`, không lưu kết quả hàm cho từng dòng. MySQL không thể xác định liên tiếp một khoảng khóa để dò, nên phải tính hàm trên nhiều dòng. Viết điều kiện trực tiếp trên cột bằng `>=` và `<` giúp truy vấn SARGable.

## 2. Thứ tự cột trong composite index

**Câu hỏi:** Vì sao index là `(transaction_type, created_at)`?

**Tóm tắt trả lời:** Truy vấn dùng phép so sánh bằng cho `transaction_type` và khoảng cho `created_at`. Quy tắc leftmost prefix cho phép MySQL thu hẹp theo loại giao dịch trước, rồi quét đúng khoảng thời gian trong nhóm đó.

## 3. `Using index condition` và `Using index`

**Câu hỏi:** Hai giá trị này trong cột `Extra` khác nhau thế nào?

**Tóm tắt trả lời:** `Using index condition` là Index Condition Pushdown: storage engine lọc thêm bằng cột index trước khi đọc bản ghi đầy đủ. `Using index` thường chỉ covering index, khi mọi cột cần thiết đã có trong index. Vì truy vấn cần `amount` nhưng index không chứa cột này, nó vẫn phải đọc bản ghi để tính tổng.

## 4. Index Seek và Index Scan

**Câu hỏi:** Index seek khác index scan ra sao?

**Tóm tắt trả lời:** Seek đi thẳng tới vùng khóa phù hợp rồi đọc một phạm vi nhỏ. Scan đọc phần lớn hoặc toàn bộ cấu trúc index. Với báo cáo một tháng, điều kiện khoảng giúp MySQL thực hiện range scan gần với seek, giảm đáng kể số dòng cần kiểm tra.
