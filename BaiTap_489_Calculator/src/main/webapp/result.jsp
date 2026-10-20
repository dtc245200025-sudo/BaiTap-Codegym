<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><title>Kết quả</title>
<style>body{font-family:Arial;text-align:center;margin-top:80px}.error{color:#b91c1c}a{color:#2563eb}</style></head><body>
<% if (request.getAttribute("error") != null) { %><h2 class="error"><%= request.getAttribute("error") %></h2>
<% } else { %><h2><%= request.getAttribute("expression") %> = <%= request.getAttribute("result") %></h2><% } %>
<a href="index.jsp">Thực hiện phép tính khác</a></body></html>
