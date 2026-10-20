-- Thực hành View trên classicmodels
USE classicmodels;

DROP VIEW IF EXISTS customer_views;

-- 1. Tạo view ban đầu.
CREATE VIEW customer_views AS
SELECT
    customerNumber,
    customerName,
    phone
FROM customers;

SELECT *
FROM customer_views
ORDER BY customerNumber;

-- 2. Sửa view: thêm tên liên hệ và chỉ giữ khách hàng ở Nantes.
CREATE OR REPLACE VIEW customer_views AS
SELECT
    customerNumber,
    customerName,
    contactFirstName,
    contactLastName,
    phone
FROM customers
WHERE city = 'Nantes'
WITH CHECK OPTION;

SELECT *
FROM customer_views
ORDER BY customerNumber;

-- Có thể kiểm tra định nghĩa trước khi xóa.
SHOW CREATE VIEW customer_views;

-- 3. Xóa view; bảng customers và dữ liệu gốc không bị ảnh hưởng.
DROP VIEW customer_views;
