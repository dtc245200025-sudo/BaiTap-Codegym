# Thực hành 470 - Hiển thị thời gian hệ thống

Dự án Maven Webapp tương thích Tomcat 10.1+, gồm `pom.xml`, `src/main/webapp/index.jsp` và `src/main/webapp/WEB-INF/web.xml`.

Mã JSP chính:

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    LocalDateTime now = LocalDateTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
%>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><title>Thời gian hệ thống</title></head>
<body>
  <h2>Thời gian hệ thống hiện tại</h2>
  <time><%= now.format(formatter) %></time>
  <a href="index.jsp">Cập nhật</a>
</body>
</html>
```

Chạy `mvn clean package`, sau đó triển khai `target/system-time.war` lên Tomcat.
