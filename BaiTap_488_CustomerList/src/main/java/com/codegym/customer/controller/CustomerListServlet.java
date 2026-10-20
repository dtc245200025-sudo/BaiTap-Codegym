package com.codegym.customer.controller;

import com.codegym.customer.model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;

@WebServlet(name = "CustomerListServlet", urlPatterns = "")
public class CustomerListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("customers", Arrays.asList(
                new Customer("Nguyễn Văn An", "12/01/1995", "Hà Nội", "images/customer-1.svg"),
                new Customer("Trần Thị Bình", "23/06/1998", "Đà Nẵng", "images/customer-2.svg"),
                new Customer("Lê Minh Cường", "05/11/1992", "TP. Hồ Chí Minh", "images/customer-3.svg")
        ));
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
