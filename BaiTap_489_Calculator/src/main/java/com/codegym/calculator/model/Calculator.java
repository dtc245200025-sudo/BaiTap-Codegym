package com.codegym.calculator.model;

public final class Calculator {
    private Calculator() {}

    public static double calculate(double firstOperand, double secondOperand, String operator) {
        switch (operator) {
            case "+": return firstOperand + secondOperand;
            case "-": return firstOperand - secondOperand;
            case "*": return firstOperand * secondOperand;
            case "/":
                if (secondOperand == 0) throw new ArithmeticException("Không thể chia cho 0");
                return firstOperand / secondOperand;
            default: throw new IllegalArgumentException("Toán tử không hợp lệ");
        }
    }
}
