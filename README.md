# Thực hành 486 - Chuyển đổi tiền tệ bằng JSP

## Cấu trúc

```text
pom.xml
src/main/webapp/index.jsp
src/main/webapp/converter.jsp
src/main/webapp/WEB-INF/web.xml
```

Form gửi `rate` và `usd` bằng POST tới `converter.jsp`:

```jsp
<form action="converter.jsp" method="POST">
  <input type="number" name="rate" value="25000" required>
  <input type="number" name="usd" required>
  <button type="submit">Tính toán</button>
</form>
```

Trang kết quả dùng Scriptlet và Expression:

```jsp
<% double rate=Double.parseDouble(request.getParameter("rate")); double usd=Double.parseDouble(request.getParameter("usd")); double vnd=rate*usd; %>
<p><%= usd %> USD = <%= vnd %> VNĐ</p>
```

Dự án Maven đóng gói WAR, dùng Java 17, Jakarta Servlet 6.0 và JSP 3.1.1 cho Tomcat 10.1+. Chạy `mvn clean package` để tạo `target/jsp-currency-converter.war`.
