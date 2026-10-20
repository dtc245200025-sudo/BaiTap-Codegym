-- Bài tập: Thao tác với CSDL Quản lý bán hàng
DROP DATABASE IF EXISTS QuanLyBanHang;
CREATE DATABASE QuanLyBanHang CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE QuanLyBanHang;

CREATE TABLE Customer (
    cID INT PRIMARY KEY,
    cName VARCHAR(25) NOT NULL,
    cAge TINYINT UNSIGNED
);

CREATE TABLE Product (
    pID INT PRIMARY KEY,
    pName VARCHAR(25) NOT NULL,
    pPrice INT NOT NULL CHECK (pPrice >= 0)
);

CREATE TABLE `Order` (
    oID INT PRIMARY KEY,
    cID INT NOT NULL,
    oDate DATETIME NOT NULL,
    oTotalPrice INT NULL,
    CONSTRAINT fk_order_customer
        FOREIGN KEY (cID) REFERENCES Customer(cID)
);

CREATE TABLE OrderDetail (
    oID INT NOT NULL,
    pID INT NOT NULL,
    odQTY INT NOT NULL CHECK (odQTY > 0),
    PRIMARY KEY (oID, pID),
    CONSTRAINT fk_order_detail_order
        FOREIGN KEY (oID) REFERENCES `Order`(oID),
    CONSTRAINT fk_order_detail_product
        FOREIGN KEY (pID) REFERENCES Product(pID)
);

INSERT INTO Customer (cID, cName, cAge) VALUES
    (1, 'Minh Quan', 10),
    (2, 'Ngoc Oanh', 20),
    (3, 'Hong Ha', 50);

INSERT INTO Product (pID, pName, pPrice) VALUES
    (1, 'May Giat', 3),
    (2, 'Tu Lanh', 5),
    (3, 'Dieu Hoa', 7),
    (4, 'Quat', 1),
    (5, 'Bep Dien', 2);

INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES
    (1, 1, '2006-03-21 00:00:00', NULL),
    (2, 2, '2006-03-23 00:00:00', NULL),
    (3, 1, '2006-03-16 00:00:00', NULL);

INSERT INTO OrderDetail (oID, pID, odQTY) VALUES
    (1, 1, 3),
    (1, 3, 7),
    (1, 4, 2),
    (2, 1, 1),
    (3, 1, 8),
    (2, 5, 4),
    (2, 3, 3);

-- 1. Mã hóa đơn, ngày mua và tổng tiền đang lưu trong bảng Order.
SELECT oID, oDate, oTotalPrice AS oPrice
FROM `Order`
ORDER BY oID;

-- 2. Khách hàng đã mua hàng và các sản phẩm họ đã mua.
SELECT DISTINCT
    c.cID,
    c.cName,
    p.pID,
    p.pName
FROM Customer AS c
JOIN `Order` AS o ON o.cID = c.cID
JOIN OrderDetail AS od ON od.oID = o.oID
JOIN Product AS p ON p.pID = od.pID
ORDER BY c.cID, p.pID;

-- 3. Khách hàng chưa từng mua sản phẩm nào.
SELECT c.cID, c.cName
FROM Customer AS c
LEFT JOIN `Order` AS o ON o.cID = c.cID
WHERE o.oID IS NULL
ORDER BY c.cID;

-- 4. Giá từng hóa đơn = tổng số lượng * đơn giá của các mặt hàng.
SELECT
    o.oID,
    o.oDate,
    SUM(od.odQTY * p.pPrice) AS oPrice
FROM `Order` AS o
JOIN OrderDetail AS od ON od.oID = o.oID
JOIN Product AS p ON p.pID = od.pID
GROUP BY o.oID, o.oDate
ORDER BY o.oID;

-- Đồng bộ giá đã tính vào cột oTotalPrice để có thể sử dụng về sau.
UPDATE `Order` AS o
JOIN (
    SELECT od.oID, SUM(od.odQTY * p.pPrice) AS total_price
    FROM OrderDetail AS od
    JOIN Product AS p ON p.pID = od.pID
    GROUP BY od.oID
) AS totals ON totals.oID = o.oID
SET o.oTotalPrice = totals.total_price;

SELECT oID, oDate, oTotalPrice AS oPrice
FROM `Order`
ORDER BY oID;
