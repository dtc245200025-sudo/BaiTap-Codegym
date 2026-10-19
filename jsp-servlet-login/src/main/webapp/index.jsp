<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>System Login</title>
  <style>
    * { box-sizing: border-box; }
    body { margin: 0; min-height: 100vh; display: grid; place-items: center; padding: 24px; background: #f1f5f9; color: #172554; font-family: Arial, sans-serif; }
    main { width: 100%; max-width: 400px; padding: 32px; border-radius: 16px; background: white; box-shadow: 0 12px 36px #17255412; }
    h1 { margin: 0 0 12px; font-size: 28px; }
    p { color: #475569; line-height: 1.6; }
    label { display: block; margin-top: 20px; font-size: 14px; font-weight: 600; }
    input { width: 100%; padding: 12px; margin-top: 8px; border: 1px solid #94a3b8; border-radius: 6px; font: inherit; }
    button { width: 100%; margin-top: 24px; padding: 13px; background: #1b2a7a; color: white; border: 0; border-radius: 6px; font: inherit; cursor: pointer; }
    button:hover { background: #283ea3; }
    :focus-visible { outline: 3px solid #2563eb; outline-offset: 3px; }
    .hint { font-size: 13px; margin-bottom: 0; }
  </style>
</head>
<body>
  <main>
    <h1>System Login</h1>
    <p>Đăng nhập để xem lời chào từ website.</p>
    <form action="login" method="POST">
      <label for="username">Tên đăng nhập</label>
      <input id="username" type="text" name="username" autocomplete="username" placeholder="Enter username" required>
      <label for="password">Mật khẩu</label>
      <input id="password" type="password" name="password" autocomplete="current-password" placeholder="Enter password" required>
      <button type="submit">Login</button>
    </form>
    <p class="hint">Tài khoản thực hành: <strong>admin / admin</strong></p>
  </main>
</body>
</html>
