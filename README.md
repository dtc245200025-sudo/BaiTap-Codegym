# Thực hành 486 - Chuyển đổi tiền tệ bằng JSP

Ứng dụng nhận tỉ giá và số USD từ `index.jsp`, gửi bằng `POST`, rồi dùng JSP Scriptlet và Expression trong `converter.jsp` để tính và hiển thị số tiền VNĐ.

## Cấu trúc mã nguồn thực tế

```text
pom.xml
src/main/webapp/index.jsp
src/main/webapp/converter.jsp
src/main/webapp/WEB-INF/web.xml
```

## pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.codegym</groupId>
  <artifactId>jsp-currency-converter</artifactId>
  <version>1.0-SNAPSHOT</version>
  <packaging>war</packaging>
  <properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  </properties>
  <dependencies>
    <dependency>
      <groupId>jakarta.servlet</groupId>
      <artifactId>jakarta.servlet-api</artifactId>
      <version>6.0.0</version>
      <scope>provided</scope>
    </dependency>
    <dependency>
      <groupId>jakarta.servlet.jsp</groupId>
      <artifactId>jakarta.servlet.jsp-api</artifactId>
      <version>3.1.1</version>
      <scope>provided</scope>
    </dependency>
  </dependencies>
  <build>
    <finalName>jsp-currency-converter</finalName>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-war-plugin</artifactId>
        <version>3.4.0</version>
      </plugin>
    </plugins>
  </build>
</project>
```

## src/main/webapp/WEB-INF/web.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
         version="6.0">
  <welcome-file-list>
    <welcome-file>index.jsp</welcome-file>
  </welcome-file-list>
</web-app>
```

## src/main/webapp/index.jsp

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><title>Chuyển đổi tiền tệ</title></head>
<body>
  <h2>USD sang VNĐ</h2>
  <form action="converter.jsp" method="POST">
    <label>Tỉ giá (VNĐ/USD)
      <input type="number" name="rate" value="25000" step="any" min="0" required>
    </label>
    <label>Lượng USD
      <input type="number" name="usd" step="any" min="0" required>
    </label>
    <button type="submit">Tính toán</button>
  </form>
</body>
</html>
```

## src/main/webapp/converter.jsp

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String error = null;
  double rate = 0, usd = 0, vnd = 0;
  try {
    rate = Double.parseDouble(request.getParameter("rate"));
    usd = Double.parseDouble(request.getParameter("usd"));
    if (rate < 0 || usd < 0) throw new IllegalArgumentException();
    vnd = rate * usd;
  } catch (Exception exception) {
    error = "Dữ liệu đầu vào không hợp lệ";
  }
%>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><title>Kết quả chuyển đổi</title></head>
<body>
  <h2>Kết quả chuyển đổi</h2>
  <% if (error == null) { %>
    <p><%= usd %> USD × <%= rate %> =</p>
    <h3><%= String.format("%,.0f", vnd) %> VNĐ</h3>
  <% } else { %>
    <h3><%= error %></h3>
  <% } %>
  <a href="index.jsp">Quay lại</a>
</body>
</html>
```

## Chạy dự án

Chạy `mvn clean package`, sau đó triển khai `target/jsp-currency-converter.war` lên Tomcat 10.1 trở lên.
