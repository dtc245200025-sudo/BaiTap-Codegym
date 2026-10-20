<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><title>Máy tính</title>
<style>body{font-family:Arial;background:#f4f6f8}main{width:360px;margin:80px auto;padding:24px;background:white;border-radius:10px;box-shadow:0 4px 16px #0002}input,select,button{box-sizing:border-box;width:100%;margin-top:10px;padding:10px}button{color:white;background:#2563eb;border:0;border-radius:6px;cursor:pointer}</style>
</head><body><main><h1>Máy tính cơ bản</h1><form action="calculate" method="post">
<label>Số thứ nhất<input type="number" step="any" name="firstOperand" required></label>
<label>Phép tính<select name="operator"><option value="+">Cộng (+)</option><option value="-">Trừ (-)</option><option value="*">Nhân (*)</option><option value="/">Chia (/)</option></select></label>
<label>Số thứ hai<input type="number" step="any" name="secondOperand" required></label><button type="submit">Tính kết quả</button>
</form></main></body></html>
