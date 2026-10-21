package com.codegym;

import java.security.NoSuchAlgorithmException;

public class Main {
    public static void main(String[] args) {
        System.out.println("Kết quả gọi từ thư viện đóng gói (.jar):");
        System.out.println("Tổng 2 số (5, 9): " + Calculator.sum(5, 9));
        System.out.println("Hiệu 2 số (5, 9): " + Calculator.sub(5, 9));
        System.out.println("Tích 2 số (5, 9): " + Calculator.mul(5, 9));
        try {
            System.out.println("Thương 2 số (10, 5): " + Calculator.divide(10, 5));
        } catch (NoSuchAlgorithmException e) {
            System.err.println("Lỗi thuật toán: " + e.getMessage());
        }
    }
}
