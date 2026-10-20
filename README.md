# Thực hành 510 - Quản lý User bằng JSP, Servlet, JDBC và MySQL

Dự án Maven Webapp theo MVC, tương thích Tomcat 10.1+. Chạy `database.sql` để tạo CSDL `demo` và bảng `users`; sửa tài khoản MySQL trong `UserDAO` nếu cần.

## Cấu trúc

```text
database.sql
pom.xml
src/main/java/com/codegym/model/User.java
src/main/java/com/codegym/dao/IUserDAO.java
src/main/java/com/codegym/dao/UserDAO.java
src/main/java/com/codegym/controller/UserServlet.java
src/main/webapp/user/list.jsp
src/main/webapp/user/create.jsp
src/main/webapp/user/edit.jsp
src/main/webapp/user/delete.jsp
src/main/webapp/WEB-INF/web.xml
```

`UserDAO` dùng `PreparedStatement` và try-with-resources cho đủ bốn thao tác CRUD. `UserServlet` ánh xạ `/users`, điều hướng `list`, `new`, `edit`, `delete` và xử lý `insert`, `update`, `delete` bằng POST. Chạy `mvn clean package`, triển khai `target/user-management.war` lên Tomcat.
