# Thực hành 498 - Ứng dụng quản lý khách hàng MVC

Dự án Maven Webapp triển khai đủ MVC: `Customer` (Model), `CustomerService` (Service), `CustomerServlet` (Controller), các JSP (View). Hỗ trợ danh sách, xem, thêm, sửa và xóa khách hàng tại `/customers`.

```java
@WebServlet("/customers")
public class CustomerServlet extends HttpServlet {
  // GET: list/create/edit/view/delete; POST: lưu khách hàng
}
```

Cấu trúc chính: `pom.xml`, `src/main/java/com/codegym/{model,service,controller}`, `src/main/webapp/customer/{list,form,view}.jsp`, `WEB-INF/web.xml`. Chạy `mvn clean package` và triển khai `target/customer-management.war` lên Tomcat 10.1+.
