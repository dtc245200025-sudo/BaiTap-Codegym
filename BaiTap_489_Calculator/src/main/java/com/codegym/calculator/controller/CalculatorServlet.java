package com.codegym.calculator.controller;

import com.codegym.calculator.model.Calculator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "CalculatorServlet", urlPatterns = "/calculate")
public class CalculatorServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            double first = Double.parseDouble(request.getParameter("firstOperand"));
            double second = Double.parseDouble(request.getParameter("secondOperand"));
            String operator = request.getParameter("operator");
            request.setAttribute("result", Calculator.calculate(first, second, operator));
            request.setAttribute("expression", first + " " + operator + " " + second);
        } catch (NumberFormatException exception) {
            request.setAttribute("error", "Vui lòng nhập hai số hợp lệ");
        } catch (ArithmeticException | IllegalArgumentException exception) {
            request.setAttribute("error", exception.getMessage());
        }
        request.getRequestDispatcher("/result.jsp").forward(request, response);
    }
}
