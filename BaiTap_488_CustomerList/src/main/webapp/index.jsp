<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><title>Danh sách khách hàng</title>
<style>body{font-family:Arial;background:#f6f7fb;margin:0;padding:40px}main{max-width:850px;margin:auto;background:white;padding:28px;border-radius:12px;box-shadow:0 4px 18px #0002}table{width:100%;border-collapse:collapse}th,td{padding:12px;border-bottom:1px solid #ddd;text-align:left}th{background:#2563eb;color:white}img{width:64px;height:64px;border-radius:50%;object-fit:cover}</style>
</head><body><main><h1>Danh sách khách hàng</h1><table><thead><tr><th>Ảnh</th><th>Họ tên</th><th>Ngày sinh</th><th>Địa chỉ</th></tr></thead><tbody>
<c:forEach var="customer" items="${customers}"><tr><td><img src="${customer.image}" alt="Ảnh ${customer.name}"></td><td>${customer.name}</td><td>${customer.birthday}</td><td>${customer.address}</td></tr></c:forEach>
</tbody></table></main></body></html>
