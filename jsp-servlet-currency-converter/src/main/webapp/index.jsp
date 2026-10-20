<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chuyển đổi USD sang VNĐ</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            min-height: 100vh;
            display: grid;
            place-items: center;
            padding: 24px;
            background: linear-gradient(145deg, #edf4ff, #f8fafc 55%, #e8f6f0);
            color: #172554;
            font-family: Arial, sans-serif;
        }
        main {
            width: 100%;
            max-width: 440px;
            padding: 36px;
            border: 1px solid #dbe3ef;
            border-radius: 18px;
            background: white;
            box-shadow: 0 20px 50px rgba(23, 37, 84, .10);
        }
        .eyebrow { margin: 0 0 10px; color: #16725d; font-size: 12px; font-weight: 700; letter-spacing: 2px; }
        h1 { margin: 0 0 12px; font-size: 28px; }
        .description { margin: 0 0 26px; color: #64748b; line-height: 1.6; }
        label { display: block; margin-top: 18px; color: #334155; font-size: 14px; font-weight: 700; }
        input {
            width: 100%;
            margin-top: 8px;
            padding: 13px;
            border: 1px solid #94a3b8;
            border-radius: 8px;
            font: inherit;
        }
        button {
            width: 100%;
            margin-top: 26px;
            padding: 14px;
            border: 0;
            border-radius: 8px;
            background: #1b2a7a;
            color: white;
            font: inherit;
            font-weight: 700;
            cursor: pointer;
        }
        button:hover { background: #283ea3; }
        :focus-visible { outline: 3px solid #2563eb; outline-offset: 3px; }
        .hint { margin: 18px 0 0; color: #64748b; font-size: 13px; text-align: center; }
    </style>
</head>
<body>
<main>
    <p class="eyebrow">CURRENCY CONVERTER</p>
    <h1>Chuyển đổi USD sang VNĐ</h1>
    <p class="description">Nhập tỉ giá và số USD cần chuyển đổi.</p>

    <form action="convert" method="POST">
        <label for="rate">Tỉ giá (VND/USD)</label>
        <input id="rate" type="number" name="rate" value="25000" min="0.01" step="any" required>

        <label for="usd">Lượng USD cần đổi</label>
        <input id="usd" type="number" name="usd" placeholder="Ví dụ: 100" min="0" step="any" required>

        <button type="submit">Chuyển đổi</button>
    </form>
    <p class="hint">Công thức: VNĐ = USD × Tỉ giá</p>
</main>
</body>
</html>
