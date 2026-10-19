package com.codegym;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        response.setHeader("Cache-Control", "no-store");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean valid = "admin".equals(username) && "admin".equals(password);

        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'>");
            out.println("<meta name='viewport' content='width=device-width, initial-scale=1'>");
            out.println("<title>Login Result</title></head>");
            out.println("<body style='font-family:Arial,sans-serif;text-align:center;padding:64px 16px'>");
            if (valid) {
                out.println("<h1 style='color:#166534'>Welcome admin to website</h1>");
            } else {
                out.println("<h1 style='color:#b91c1c'>Login Error</h1>");
            }
            out.println("<p><a href='index.jsp'>Go back</a></p></body></html>");
        }
    }
}
