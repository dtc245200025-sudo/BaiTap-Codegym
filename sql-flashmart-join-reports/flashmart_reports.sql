CREATE DATABASE IF NOT EXISTS flashmart_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE flashmart_db;

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES Customers (customer_id),
    CONSTRAINT fk_orders_product
        FOREIGN KEY (product_id) REFERENCES Products (product_id)
);

INSERT INTO Customers (customer_id, name)
VALUES
    (1, 'Alice'),
    (2, 'Bob'),
    (3, 'Charlie');

INSERT INTO Products (product_id, product_name)
VALUES
    (101, 'Laptop'),
    (102, 'Mouse'),
    (103, 'Keyboard');

INSERT INTO Orders (order_id, customer_id, product_id)
VALUES
    (1001, 1, 101),
    (1002, 1, 102),
    (1003, 2, 101);

-- Báo cáo Marketing: giữ đầy đủ khách hàng, kể cả người chưa mua hàng.
SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders
FROM Customers AS c
LEFT JOIN Orders AS o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY c.customer_id;

-- Báo cáo Kho vận: tìm sản phẩm chưa từng xuất hiện trong đơn hàng.
SELECT
    p.product_id,
    p.product_name
FROM Products AS p
LEFT JOIN Orders AS o ON o.product_id = p.product_id
WHERE o.order_id IS NULL
ORDER BY p.product_id;
