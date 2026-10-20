-- Bài tập tổng hợp View, Index và Stored Procedure
DROP DATABASE IF EXISTS product_management;
CREATE DATABASE product_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE product_management;

CREATE TABLE Products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(12, 2) NOT NULL CHECK (productPrice >= 0),
    productAmount INT NOT NULL CHECK (productAmount >= 0),
    productDescription VARCHAR(255),
    productStatus BOOLEAN NOT NULL DEFAULT TRUE
);

INSERT INTO Products
    (productCode, productName, productPrice, productAmount, productDescription, productStatus)
VALUES
    ('P001', 'Laptop Pro', 25000000, 10, 'Laptop cho lập trình viên', TRUE),
    ('P002', 'Wireless Mouse', 450000, 50, 'Chuột không dây', TRUE),
    ('P003', 'Mechanical Keyboard', 1800000, 25, 'Bàn phím cơ', TRUE),
    ('P004', 'Office Monitor', 5200000, 15, 'Màn hình 27 inch', TRUE),
    ('P005', 'Legacy Headset', 700000, 0, 'Mẫu đã ngừng bán', FALSE);

-- ========================================================
-- INDEX VÀ EXPLAIN
-- ========================================================

-- Trước khi tạo index ngoài khóa chính.
EXPLAIN SELECT * FROM Products WHERE productCode = 'P003';
EXPLAIN SELECT * FROM Products
WHERE productName = 'Office Monitor' AND productPrice = 5200000;

CREATE UNIQUE INDEX idx_product_code ON Products(productCode);
CREATE INDEX idx_product_name_price ON Products(productName, productPrice);

-- Sau khi tạo index: key phải hiển thị index tương ứng.
EXPLAIN SELECT * FROM Products WHERE productCode = 'P003';
EXPLAIN SELECT * FROM Products
WHERE productName = 'Office Monitor' AND productPrice = 5200000;

SHOW INDEX FROM Products;

-- ========================================================
-- VIEW
-- ========================================================

CREATE VIEW product_view AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

SELECT * FROM product_view ORDER BY productCode;

-- Sửa view để chỉ công khai sản phẩm đang bán và thêm số lượng.
CREATE OR REPLACE VIEW product_view AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products
WHERE productStatus = TRUE
WITH CHECK OPTION;

SELECT * FROM product_view ORDER BY productCode;
DROP VIEW product_view;

-- ========================================================
-- STORED PROCEDURES CRUD
-- ========================================================

DELIMITER //

CREATE PROCEDURE getAllProducts()
BEGIN
    SELECT * FROM Products ORDER BY id;
END//

CREATE PROCEDURE addProduct(
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(12, 2),
    IN p_amount INT,
    IN p_description VARCHAR(255),
    IN p_status BOOLEAN
)
BEGIN
    INSERT INTO Products
        (productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES
        (p_code, p_name, p_price, p_amount, p_description, p_status);
END//

CREATE PROCEDURE updateProduct(
    IN p_id INT,
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(12, 2),
    IN p_amount INT,
    IN p_description VARCHAR(255),
    IN p_status BOOLEAN
)
BEGIN
    UPDATE Products
    SET productCode = p_code,
        productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_description,
        productStatus = p_status
    WHERE id = p_id;
END//

CREATE PROCEDURE deleteProduct(IN p_id INT)
BEGIN
    DELETE FROM Products WHERE id = p_id;
END//

DELIMITER ;

-- Kiểm thử đủ bốn procedure trong một giao dịch có thể hoàn tác.
START TRANSACTION;
CALL getAllProducts();
CALL addProduct('P006', 'USB-C Hub', 950000, 30, 'Hub 7 trong 1', TRUE);
SET @new_product_id = LAST_INSERT_ID();
CALL updateProduct(@new_product_id, 'P006', 'USB-C Hub Plus', 1050000, 28, 'Hub 8 trong 1', TRUE);
CALL deleteProduct(@new_product_id);
ROLLBACK;

CALL getAllProducts();
