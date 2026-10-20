package com.codegym;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "DiscountServlet", urlPatterns = "/display-discount")
public class DiscountServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String description = request.getParameter("description");
        try {
            double listPrice = Double.parseDouble(request.getParameter("listPrice"));
            double discountPercent = Double.parseDouble(request.getParameter("discountPercent"));
            if (listPrice < 0 || discountPercent < 0 || discountPercent > 100) {
                throw new IllegalArgumentException();
            }

            double discountAmount = listPrice * discountPercent * 0.01;
            double discountPrice = listPrice - discountAmount;

            request.setAttribute("description", description);
            request.setAttribute("listPrice", listPrice);
            request.setAttribute("discountPercent", discountPercent);
            request.setAttribute("discountAmount", discountAmount);
            request.setAttribute("discountPrice", discountPrice);
            request.getRequestDispatcher("/result.jsp").forward(request, response);
        } catch (IllegalArgumentException exception) {
            request.setAttribute("error", "Giá và tỷ lệ chiết khấu không hợp lệ.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}
