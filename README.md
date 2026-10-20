# Thực hành 527 - Thực thi SQL có sử dụng Transaction

Dự án bổ sung `insertUpdateUseTransaction()` vào `IUserDAO` và `UserDAO`, cùng action `/users?action=test-use-tran` trong `UserServlet`.

```java
Connection c = connection();
c.setAutoCommit(false);
try {
  // tạo bảng; INSERT Quynh, Ngan; UPDATE lương Quynh
  c.commit();
} catch (Exception e) {
  c.rollback();
  throw e;
} finally {
  c.setAutoCommit(true);
}
```

Mọi INSERT và UPDATE thuộc một Transaction: thành công thì `commit`, bất kỳ lỗi nào thì `rollback`, bảo đảm nguyên tắc All-or-Nothing. Phiên bản hoàn chỉnh dùng đúng chỉ số tham số UPDATE và cập nhật lương Quynh thành `999.99`. Thông tin MySQL lấy từ `DB_USER` và `DB_PASSWORD`.
