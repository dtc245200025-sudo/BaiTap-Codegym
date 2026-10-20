<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    LocalDateTime now = LocalDateTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
%>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><title>Thời gian hệ thống</title>
<style>body{font-family:Arial;background:#f1f5f9;display:flex;justify-content:center;margin-top:120px}.clock{background:white;padding:40px 60px;text-align:center;border-radius:12px;box-shadow:0 5px 18px #0002}time{font-size:30px;color:#1b2a7a;font-weight:bold}</style></head>
<body><main class="clock"><h2>Thời gian hệ thống hiện tại</h2><time><%= now.format(formatter) %></time><p><a href="index.jsp">Cập nhật</a></p></main></body></html>
