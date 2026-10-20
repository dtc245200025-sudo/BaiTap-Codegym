<%@ page import="java.util.Map,java.util.HashMap" %><%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
request.setCharacterEncoding("UTF-8");
Map<String,String> dictionary = new HashMap<>();
dictionary.put("hello", "Xin chào"); dictionary.put("book", "Quyển sách"); dictionary.put("computer", "Máy tính"); dictionary.put("student", "Sinh viên");
String search = request.getParameter("search");
String result = search == null ? null : dictionary.get(search.trim().toLowerCase());
%>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><title>Kết quả tra cứu</title>
<style>body{font-family:Arial;text-align:center;margin-top:100px;background:#f8fafc}.box{display:inline-block;background:white;padding:40px;border-radius:8px;box-shadow:0 4px 10px #0002}.ok{color:#15803d}.error{color:#b91c1c}</style></head><body><div class="box"><h2>Kết quả tra cứu</h2>
<% if (result != null) { %><p>Từ <strong><%= search %></strong> có nghĩa là:</p><h3 class="ok"><%= result %></h3><% } else { %><h3 class="error">Không tìm thấy từ “<%= search %>”</h3><% } %>
<a href="index.jsp">Quay lại</a></div></body></html>
