<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Product Discount Calculator</title>
    <style>
        body{font-family:Arial;background:#f4f7fb;display:flex;justify-content:center;margin-top:70px}
        .card{width:420px;background:#fff;padding:32px;border-radius:12px;box-shadow:0 5px 18px #0002}
        label{display:block;margin-top:14px;font-weight:bold}input,button{box-sizing:border-box;width:100%;padding:11px;margin-top:6px}
        button{background:#1b2a7a;color:#fff;border:0;border-radius:6px;margin-top:22px}.error{color:#b91c1c}
    </style>
</head>
<body><main class="card">
    <h2>Product Discount Calculator</h2>
    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>
    <form action="display-discount" method="post">
        <label>Product Description
            <input type="text" name="description" required>
        </label>
        <label>List Price
            <input type="number" name="listPrice" min="0" step="0.01" required>
        </label>
        <label>Discount Percent
            <input type="number" name="discountPercent" min="0" max="100" step="0.01" required>
        </label>
        <button type="submit">Calculate Discount</button>
    </form>
</main></body>
</html>
