<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><title>Discount Result</title>
    <style>body{font-family:Arial;background:#f4f7fb;display:flex;justify-content:center;margin-top:70px}.card{width:420px;background:white;padding:32px;border-radius:12px;box-shadow:0 5px 18px #0002}.total{color:#15803d;font-size:22px}a{display:inline-block;margin-top:16px}</style>
</head>
<body><main class="card">
    <h2>Discount Result</h2>
    <p>Product: <strong>${description}</strong></p>
    <p>List Price: ${String.format("%,.2f", listPrice)}</p>
    <p>Discount Percent: ${discountPercent}%</p>
    <p>Discount Amount: ${String.format("%,.2f", discountAmount)}</p>
    <p class="total">Discount Price: ${String.format("%,.2f", discountPrice)}</p>
    <a href="index.jsp">Calculate again</a>
</main></body>
</html>
