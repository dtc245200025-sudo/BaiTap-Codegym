# Thực hành 526 - Thực thi SQL không sử dụng Transaction

Dự án kế thừa ứng dụng quản lý User JDBC/MySQL và bổ sung `Employee` cùng phương thức `insertUpdateWithoutTransaction()` trong `IUserDAO`/`UserDAO`.

Phương thức xóa và tạo lại bảng, chèn `Quynh`, `Ngan`, sau đó cố tình gán sai tham số câu UPDATE. Vì `autoCommit` vẫn bật, hai INSERT đã được ghi dù UPDATE thất bại, minh họa rác dữ liệu khi không dùng Transaction.

```java
public void insertUpdateWithoutTransaction() throws SQLException {
  try (Connection c = connection();
       PreparedStatement ins = c.prepareStatement("INSERT INTO Employee(name,salary,created_Date) VALUES(?,?,?)");
       PreparedStatement upd = c.prepareStatement("UPDATE Employee SET salary=? WHERE name=?")) {
    // chèn Quynh và Ngan; mỗi lệnh tự động commit
    upd.setBigDecimal(2, new BigDecimal("999.99")); // cố tình bỏ tham số 1
    upd.setString(2, "Quynh");
    upd.executeUpdate();
  }
}
```

`UserServlet` cung cấp URL `/users?action=test-without-tran`. Thông tin đăng nhập lấy từ biến môi trường `DB_USER` và `DB_PASSWORD`. Toàn bộ mã nguồn Maven, DAO, Servlet, JSP và `database.sql` có trong nhánh này.
