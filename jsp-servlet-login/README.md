# Đăng nhập bằng JSP/Servlet

Bài tập Java Web: nhận dữ liệu form bằng POST và hiển thị lời chào.

## Công nghệ và cấu trúc

- Java 17+, Maven; triển khai trên Tomcat 10.1.
- `groupId`: `com.codegym`; `artifactId`: `jsp-servlet-login`; đóng gói WAR.
- Jakarta Servlet API 6.0 và JSP API 3.1 được khai báo `provided` vì Tomcat cung cấp khi chạy.
- Tham khảo tương thích: https://tomcat.apache.org/whichversion.html

```text
jsp-servlet-login/
├── pom.xml
├── README.md
└── src/main/
    ├── java/com/codegym/LoginServlet.java
    └── webapp/
        ├── index.jsp
        └── WEB-INF/web.xml
```

## Chạy bài

1. Cài JDK 17+ và Maven, cấu hình `JAVA_HOME` trỏ tới JDK.
2. Mở terminal trong thư mục `jsp-servlet-login` rồi chạy:

   ```sh
   mvn clean package
   ```

3. Copy `target/jsp-servlet-login.war` vào thư mục `webapps` của Tomcat 10.1.
4. Khởi động Tomcat: Windows chạy `bin/startup.bat`; Linux/macOS chạy `bin/startup.sh`.
5. Truy cập http://localhost:8080/jsp-servlet-login/.

Không mở `index.jsp` trực tiếp bằng file:// hoặc Live Server vì JSP cần máy chủ Java xử lý.

## Kiểm tra chức năng

| Dữ liệu gửi bằng POST tới `/login` | Kết quả |
| --- | --- |
| username=`admin`, password=`admin` | `Welcome admin to website` |
| username=`admin`, password sai | `Login Error` |
| username sai, password=`admin` | `Login Error` |
| Cả hai sai hoặc thiếu tham số | `Login Error` |

Form có nhãn cho hai ô nhập, ô mật khẩu dùng `type="password"`, phương thức `POST` và `action="login"` để hoạt động dưới context `/jsp-servlet-login`. Trang GET hiển thị form; Servlet dùng `doPost` đọc `request.getParameter(...)`. Truy cập GET trực tiếp `/login` không thực hiện đăng nhập (HTTP 405).

So sánh bằng `"admin".equals(...)` tránh lỗi khi request thiếu tham số. Servlet chỉ xuất thông báo cố định, không đưa dữ liệu người dùng vào HTML. Đây là bài tập dùng tài khoản cố định theo đề, chưa triển khai database hay phiên đăng nhập.

## Kết quả kiểm thử

Đã chạy `mvn clean package`: **BUILD SUCCESS**, tạo `target/jsp-servlet-login.war`.
Đã triển khai WAR trên Tomcat 10.1.61 trong môi trường kiểm thử cục bộ và gửi HTTP thực tế:

- GET trang gốc: HTTP 200, JSP biên dịch và hiển thị form POST.
- POST `admin/admin`: `Welcome admin to website`.
- POST sai mật khẩu, sai tên, sai cả hai, không có tham số, tên `Admin` khác chữ hoa/thường: đều `Login Error`.
- GET `/login`: HTTP 405, không xử lý đăng nhập bằng GET.

Máy chủ kiểm thử được dừng sau khi kiểm tra xong.
