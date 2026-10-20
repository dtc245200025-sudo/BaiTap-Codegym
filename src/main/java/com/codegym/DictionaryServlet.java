package com.codegym;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

@WebServlet(name = "DictionaryServlet", urlPatterns = "/translate")
public class DictionaryServlet extends HttpServlet {
    private final Map<String, String> dictionary = new HashMap<>();

    @Override public void init() {
        dictionary.put("hello", "xin chào");
        dictionary.put("book", "quyển sách");
        dictionary.put("computer", "máy tính");
        dictionary.put("student", "học sinh");
        dictionary.put("teacher", "giáo viên");
    }

    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String word = request.getParameter("word").trim().toLowerCase(Locale.ROOT);
        String result = dictionary.get(word);
        request.setAttribute("word", word);
        request.setAttribute("result", result);
        request.getRequestDispatcher("/result.jsp").forward(request, response);
    }
}
