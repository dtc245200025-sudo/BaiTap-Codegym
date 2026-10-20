# JSP/Servlet Currency Converter

Ứng dụng Maven Webapp chuyển đổi USD sang VNĐ bằng công thức `VND = USD × Rate`.

## Công nghệ

- Java 17+
- Jakarta Servlet API 6.0 và JSP API 3.1
- Maven, đóng gói WAR
- Apache Tomcat 10.1+

## Cấu trúc

```text
jsp-servlet-currency-converter/
├── pom.xml
└── src/main/
    ├── java/com/codegym/ConverterServlet.java
    └── webapp/
        ├── index.jsp
        └── WEB-INF/web.xml
```

## Chạy ứng dụng

1. Mở terminal tại thư mục `jsp-servlet-currency-converter`.
2. Chạy `mvn clean package`.
3. Copy `target/jsp-servlet-currency-converter.war` vào thư mục `webapps` của Tomcat 10.1.
4. Khởi động Tomcat và truy cập <http://localhost:8080/jsp-servlet-currency-converter/>.

Không mở `index.jsp` trực tiếp bằng `file://` hoặc Live Server vì JSP cần máy chủ Java xử lý.

## Kiểm thử

| Tỉ giá | USD | Kết quả |
| ---: | ---: | --- |
| 25.000 | 100 | 2.500.000 VNĐ |
| 25.000,5 | 1,5 | 37.500,75 VNĐ |
| 0 hoặc số âm | bất kỳ | HTTP 400 và thông báo lỗi |
| hợp lệ | USD âm | HTTP 400 và thông báo lỗi |
| thiếu hoặc không phải số | bất kỳ | HTTP 400 và thông báo lỗi |

Form gửi dữ liệu bằng `POST` tới `/convert`. Servlet dùng `BigDecimal` để tránh sai số thường gặp khi tính tiền với `float` hoặc `double`.

## Kết quả xác minh

- Maven đóng gói thành công và tạo `target/jsp-servlet-currency-converter.war`.
- WAR chạy thành công trên Apache Tomcat 10.1.61.
- GET trang gốc trả HTTP 200 và hiển thị đầy đủ form JSP.
- `rate=25000`, `usd=100` trả `2.500.000 VNĐ`.
- `rate=25000.5`, `usd=1.5` trả `37.500,75 VNĐ`.
- Tỉ giá bằng 0, số USD âm, dữ liệu không phải số và request thiếu tham số đều trả HTTP 400 kèm thông báo lỗi.
- GET trực tiếp `/convert` trả HTTP 405 vì chức năng chỉ xử lý POST.
