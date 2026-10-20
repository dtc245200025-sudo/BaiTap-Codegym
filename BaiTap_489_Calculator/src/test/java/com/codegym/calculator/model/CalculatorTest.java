package com.codegym.calculator.model;

public class CalculatorTest {
    public static void main(String[] args) {
        check(7, Calculator.calculate(3, 4, "+")); check(-1, Calculator.calculate(3, 4, "-"));
        check(12, Calculator.calculate(3, 4, "*")); check(2.5, Calculator.calculate(5, 2, "/"));
        try { Calculator.calculate(10, 0, "/"); throw new AssertionError("Phải phát sinh lỗi"); }
        catch (ArithmeticException expected) { }
        System.out.println("CalculatorTest: PASS");
    }
    private static void check(double expected, double actual) {
        if (Double.compare(expected, actual) != 0) throw new AssertionError("Expected " + expected + " but got " + actual);
    }
}
