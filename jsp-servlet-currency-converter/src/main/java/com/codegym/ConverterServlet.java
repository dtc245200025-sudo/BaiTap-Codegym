package com.codegym;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ConverterServlet", urlPatterns = "/convert")
public class ConverterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        response.setHeader("Cache-Control", "no-store");

        String rateInput = request.getParameter("rate");
        String usdInput = request.getParameter("usd");

        try (PrintWriter out = response.getWriter()) {
            try {
                BigDecimal rate = new BigDecimal(rateInput);
                BigDecimal usd = new BigDecimal(usdInput);

                if (rate.signum() <= 0 || usd.signum() < 0) {
                    throw new IllegalArgumentException("Tỉ giá phải lớn hơn 0 và lượng USD không được âm.");
                }

                BigDecimal vnd = rate.multiply(usd);
                NumberFormat vndFormat = NumberFormat.getNumberInstance(Locale.forLanguageTag("vi-VN"));
                vndFormat.setMaximumFractionDigits(2);
                NumberFormat usdFormat = NumberFormat.getNumberInstance(Locale.US);
                usdFormat.setMaximumFractionDigits(2);

                renderPage(out, "Kết quả chuyển đổi",
                        "<p>Tỉ giá: <strong>" + vndFormat.format(rate) + " VND/USD</strong></p>"
                        + "<p>Số tiền: <strong>" + usdFormat.format(usd) + " USD</strong></p>"
                        + "<p class='result'>Thành tiền: " + vndFormat.format(vnd) + " VNĐ</p>", false);
            } catch (NumberFormatException | NullPointerException exception) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                renderPage(out, "Dữ liệu không hợp lệ",
                        "<p>Vui lòng nhập tỉ giá và lượng USD bằng số hợp lệ.</p>", true);
            } catch (IllegalArgumentException exception) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                renderPage(out, "Dữ liệu không hợp lệ",
                        "<p>Tỉ giá phải lớn hơn 0 và lượng USD không được âm.</p>", true);
            }
        }
    }

    private void renderPage(PrintWriter out, String title, String content, boolean error) {
        String color = error ? "#b91c1c" : "#166534";
        out.println("<!DOCTYPE html><html lang='vi'><head><meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1'>");
        out.println("<title>" + title + "</title><style>");
        out.println("body{font-family:Arial,sans-serif;background:#f1f5f9;color:#334155;text-align:center;padding:64px 16px}");
        out.println("main{max-width:560px;margin:auto;background:white;padding:36px;border-radius:16px;box-shadow:0 12px 36px #17255412}");
        out.println("h1,.result{color:" + color + ";}.result{font-size:24px;font-weight:700}");
        out.println("a{display:inline-block;margin-top:20px;padding:11px 18px;background:#1b2a7a;color:white;text-decoration:none;border-radius:7px}");
        out.println("</style></head><body><main><h1>" + title + "</h1>");
        out.println(content);
        out.println("<a href='index.jsp'>Quay lại</a></main></body></html>");
    }
}
