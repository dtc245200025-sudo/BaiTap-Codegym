# Thực hành 473 - Từ điển Anh Việt bằng Servlet

Mã nguồn dự án Maven Webapp nằm trực tiếp trong nhánh, gồm `pom.xml`, `DictionaryServlet.java`, `index.jsp`, `result.jsp` và `WEB-INF/web.xml`.

## Logic Servlet đầy đủ

```java
@WebServlet(name = "DictionaryServlet", urlPatterns = "/translate")
public class DictionaryServlet extends HttpServlet {
    private final Map<String, String> dictionary = new HashMap<>();
    @Override public void init() {
        dictionary.put("hello", "xin chào");
        dictionary.put("book", "quyển sách");
        dictionary.put("computer", "máy tính");
        dictionary.put("student", "học sinh");
        dictionary.put("teacher", "giáo viên");
    }
    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String word = request.getParameter("word").trim().toLowerCase(Locale.ROOT);
        request.setAttribute("word", word);
        request.setAttribute("result", dictionary.get(word));
        request.getRequestDispatcher("/result.jsp").forward(request, response);
    }
}
```

Form gửi đúng `POST` đến `/translate`:

```jsp
<form action="translate" method="POST">
  <input type="text" name="word" required autofocus>
  <button type="submit">Tìm kiếm</button>
</form>
```

Chạy `mvn clean package`, triển khai `target/jsp-servlet-dictionary.war` lên Tomcat 10.1+.
