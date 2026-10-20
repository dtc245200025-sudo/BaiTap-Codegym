-- Thực hành chỉ mục trên CSDL classicmodels
USE classicmodels;

-- 1. Kế hoạch thực thi trước khi có index trên customerName.
EXPLAIN
SELECT *
FROM customers
WHERE customerName = 'Land of Toys Inc.';

-- 2. Tạo index đơn và kiểm tra lại kế hoạch.
CREATE INDEX idx_customerName ON customers(customerName);

EXPLAIN
SELECT *
FROM customers
WHERE customerName = 'Land of Toys Inc.';

-- 3. Tạo composite index cho họ và tên người liên hệ.
CREATE INDEX idx_full_name
    ON customers(contactFirstName, contactLastName);

EXPLAIN
SELECT *
FROM customers
WHERE contactFirstName IN ('Jean', 'King');

-- Truy vấn tận dụng đầy đủ tiền tố trái của composite index.
EXPLAIN
SELECT *
FROM customers
WHERE contactFirstName = 'Jean'
  AND contactLastName = 'King';

SHOW INDEX FROM customers;

-- 4. Dọn composite index sau khi thực hành.
DROP INDEX idx_full_name ON customers;

SHOW INDEX FROM customers;
