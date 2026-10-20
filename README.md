# Thực hành 487 - Ứng dụng Từ điển đơn giản bằng JSP

## Cấu trúc dự án

```text
pom.xml
src/main/webapp/index.jsp
src/main/webapp/dictionary.jsp
src/main/webapp/WEB-INF/web.xml
```

`index.jsp` chứa form `method="POST"`, input `name="search"` và gửi tới `dictionary.jsp`.

```jsp
<form action="dictionary.jsp" method="POST">
    <input type="text" name="search" required>
    <button type="submit">Tìm kiếm</button>
</form>
```

`dictionary.jsp` nhận từ khóa, tra cứu trong `Map` bằng JSP Scriptlet và hiển thị bằng Expression:

```jsp
<%@ page import="java.util.Map,java.util.HashMap" %>
<%
Map<String,String> dictionary = new HashMap<>();
dictionary.put("hello", "Xin chào");
dictionary.put("book", "Quyển sách");
dictionary.put("computer", "Máy tính");
String search = request.getParameter("search");
String result = search == null ? null : dictionary.get(search.trim().toLowerCase());
%>
<% if (result != null) { %>
    <p><%= search %> có nghĩa là <%= result %></p>
<% } else { %>
    <p>Không tìm thấy từ <%= search %></p>
<% } %>
```

`pom.xml` khai báo `packaging` là `war`, Java 17, Jakarta Servlet API 6.0.0, JSP API 3.1.1 và Maven WAR Plugin 3.4.0. `web.xml` dùng Jakarta EE Web App 6.0 và đặt `index.jsp` làm welcome file. Chạy `mvn clean package`, triển khai `target/jsp-pure-dictionary.war` trên Tomcat 10.1+.
