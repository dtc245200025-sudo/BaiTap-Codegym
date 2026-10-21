CREATE DATABASE IF NOT EXISTS product_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE product_management;
CREATE TABLE IF NOT EXISTS products(id INT PRIMARY KEY AUTO_INCREMENT,name VARCHAR(150) NOT NULL,price DECIMAL(12,2) NOT NULL,quantity INT NOT NULL);
INSERT INTO products(name,price,quantity) VALUES('Laptop Dell Inspiron',18500000,10),('Điện thoại Samsung',12900000,20),('Tai nghe Sony',1500000,35);
