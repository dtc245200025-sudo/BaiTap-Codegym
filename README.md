# Bài tập 529 - Luyện tập MySQL JDBC Transaction

Phương thức `addUserTransaction(User)` dùng một `Connection` để thêm User và ghi nhật ký `user_audit` như một đơn vị nguyên tử.

```java
connection.setAutoCommit(false);
try {
  // INSERT users và lấy generated key
  // INSERT user_audit với user_id vừa tạo
  connection.commit();
} catch (SQLException e) {
  connection.rollback();
  throw e;
} finally {
  connection.setAutoCommit(true);
}
```

Nếu câu lệnh thứ hai bị sửa sai để thử nghiệm, `rollback()` hủy cả User vừa thêm; khi cả hai lệnh đúng, `commit()` lưu đồng thời hai bản ghi. `UserServlet` gọi phương thức này cho action `insert`. `database.sql` tạo đủ bảng `users` và `user_audit`; kết nối sử dụng `DB_USER`, `DB_PASSWORD`.
