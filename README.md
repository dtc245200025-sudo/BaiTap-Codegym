# Bài tập 499 - Ứng dụng quản lý sản phẩm MVC

Dự án Maven Webapp tương thích Tomcat 10.1+, triển khai đầy đủ kiến trúc MVC và sáu chức năng: danh sách, tạo, cập nhật, xóa, xem chi tiết và tìm theo tên.

## Cấu trúc thực tế

```text
pom.xml
src/main/java/com/codegym/model/Product.java
src/main/java/com/codegym/service/ProductService.java
src/main/java/com/codegym/service/ProductServiceImpl.java
src/main/java/com/codegym/controller/ProductServlet.java
src/main/webapp/product/list.jsp
src/main/webapp/product/form.jsp
src/main/webapp/product/view.jsp
src/main/webapp/WEB-INF/web.xml
```

`Product` có đủ `id`, `name`, `price`, `description`, `manufacturer`. `ProductServiceImpl` dùng `LinkedHashMap` giả lập kho dữ liệu và hỗ trợ `findAll`, `findByName`, `findById`, `save`, `delete`. `ProductServlet` điều hướng theo `action=list|create|edit|view|delete|search`; form dùng POST để lưu.

```java
@WebServlet("/products")
public class ProductServlet extends HttpServlet {
  private final ProductService service = new ProductServiceImpl();
  // doGet điều hướng CRUD và tìm kiếm; doPost tạo hoặc cập nhật sản phẩm.
}
```

Chạy `mvn clean package` và triển khai `target/product-management.war` lên Tomcat 10.1+.
