# Nhật ký hỏi đáp lý thuyết JOIN với AI

## Câu hỏi 1

**Prompt:** Trong MySQL, từ khóa `JOIN` không ghi rõ loại sẽ hoạt động như thế nào?

**Trả lời tóm tắt:** `JOIN` mặc định là `INNER JOIN`. Nó chỉ giữ các cặp bản ghi thỏa điều kiện `ON`; bản ghi không có đối tác tương ứng ở một trong hai bảng sẽ bị loại.

## Câu hỏi 2

**Prompt:** Khi dùng `LEFT JOIN`, vì sao nên dùng `COUNT(o.order_id)` thay cho `COUNT(*)`?

**Trả lời tóm tắt:** `LEFT JOIN` vẫn sinh một dòng cho bản ghi bên trái không có kết quả khớp. `COUNT(*)` đếm dòng này, còn `COUNT(o.order_id)` bỏ qua giá trị `NULL`, nên phản ánh đúng số đơn hàng là 0.

## Câu hỏi 3

**Prompt:** `LEFT JOIN ... IS NULL` khác `NOT IN` thế nào khi tìm bản ghi không tồn tại?

**Trả lời tóm tắt:** Anti-join bằng `LEFT JOIN ... IS NULL` diễn đạt trực tiếp quan hệ không tồn tại và không gặp kết quả `UNKNOWN` do `NULL` trong tập con. `NOT EXISTS` cũng là lựa chọn rõ ràng. MySQL thường tối ưu các dạng này thành chiến lược anti-join phù hợp; vẫn nên kiểm tra bằng `EXPLAIN` trên dữ liệu thực tế.

## Kiến thức mở rộng

MySQL thường thực thi JOIN bằng các biến thể của nested-loop join. Chỉ mục trên `Orders.customer_id` và `Orders.product_id` giúp giảm số dòng phải dò khi dữ liệu lớn.
