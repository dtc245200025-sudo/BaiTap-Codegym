# Bài tập 528 - Gọi MySQL Stored Procedures từ JDBC

Ứng dụng quản lý User gọi ba Stored Procedure bằng `CallableStatement`:

- `get_users()` hiển thị danh sách.
- `update_user(id, name, email, country)` cập nhật User.
- `delete_user(id)` xóa User.

```java
CallableStatement call = connection.prepareCall("{CALL update_user(?,?,?,?)}");
call.setInt(1, user.getId());
call.setString(2, user.getName());
call.setString(3, user.getEmail());
call.setString(4, user.getCountry());
call.executeUpdate();
```

Các câu lệnh `CREATE PROCEDURE` đầy đủ nằm trong `database.sql`; `IUserDAO`, `UserDAO` và `UserServlet` đã được cập nhật để các chức năng danh sách, sửa và xóa sử dụng Stored Procedure. Kết nối lấy `DB_USER` và `DB_PASSWORD` từ biến môi trường.
