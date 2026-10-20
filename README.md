# Bài tập 474 - Product Discount Calculator

Ứng dụng Maven Webapp dùng Servlet để nhận form bằng `POST`, tính tiền chiết khấu và chuyển tiếp kết quả sang JSP.

## Cấu trúc mã nguồn

```text
pom.xml
src/main/java/com/codegym/DiscountServlet.java
src/main/webapp/index.jsp
src/main/webapp/result.jsp
src/main/webapp/WEB-INF/web.xml
```

## Công thức

```java
double discountAmount = listPrice * discountPercent * 0.01;
double discountPrice = listPrice - discountAmount;
```

## Servlet xử lý đầy đủ

```java
@WebServlet(name = "DiscountServlet", urlPatterns = "/display-discount")
public class DiscountServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String description = request.getParameter("description");
        try {
            double listPrice = Double.parseDouble(request.getParameter("listPrice"));
            double discountPercent = Double.parseDouble(request.getParameter("discountPercent"));
            if (listPrice < 0 || discountPercent < 0 || discountPercent > 100) {
                throw new IllegalArgumentException();
            }
            double discountAmount = listPrice * discountPercent * 0.01;
            double discountPrice = listPrice - discountAmount;
            request.setAttribute("description", description);
            request.setAttribute("listPrice", listPrice);
            request.setAttribute("discountPercent", discountPercent);
            request.setAttribute("discountAmount", discountAmount);
            request.setAttribute("discountPrice", discountPrice);
            request.getRequestDispatcher("/result.jsp").forward(request, response);
        } catch (IllegalArgumentException exception) {
            request.setAttribute("error", "Giá và tỷ lệ chiết khấu không hợp lệ.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}
```

Form `index.jsp` gửi đúng đến endpoint yêu cầu:

```jsp
<form action="display-discount" method="post">
  <input type="text" name="description" required>
  <input type="number" name="listPrice" min="0" step="0.01" required>
  <input type="number" name="discountPercent" min="0" max="100" step="0.01" required>
  <button type="submit">Calculate Discount</button>
</form>
```

Chạy `mvn clean package`, sau đó triển khai `target/product-discount-calculator.war` lên Tomcat 10.1+.
