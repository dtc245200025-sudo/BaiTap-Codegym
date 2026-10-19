-- Tao CSDL QuanLyBanHang theo so do de bai.
-- MySQL >= 8.0.16 (de thuc thi CHECK), InnoDB, UTF-8.
-- Chay mot lan khi CSDL chua co cac bang cung ten. Khong xoa du lieu cu.

CREATE DATABASE IF NOT EXISTS QuanLyBanHang
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE QuanLyBanHang;

CREATE TABLE Customer (
    cID INT AUTO_INCREMENT PRIMARY KEY,
    cName VARCHAR(100) NOT NULL,
    cAge INT,
    CONSTRAINT chk_customer_age CHECK (cAge >= 0)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE Product (
    pID INT AUTO_INCREMENT PRIMARY KEY,
    pName VARCHAR(100) NOT NULL,
    pPrice DECIMAL(15,2) NOT NULL,
    CONSTRAINT chk_product_price CHECK (pPrice >= 0)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- Order la tu khoa SQL: luon bao ten bang bang dau backtick.
CREATE TABLE `Order` (
    oID INT AUTO_INCREMENT PRIMARY KEY,
    cID INT NOT NULL,
    oDate DATE NOT NULL,
    oTotalPrice DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT chk_order_total CHECK (oTotalPrice >= 0),
    CONSTRAINT fk_order_customer FOREIGN KEY (cID)
        REFERENCES Customer(cID)
        ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE OrderDetail (
    oID INT NOT NULL,
    pID INT NOT NULL,
    odQTY INT NOT NULL,
    CONSTRAINT pk_order_detail PRIMARY KEY (oID, pID),
    CONSTRAINT chk_order_detail_quantity CHECK (odQTY > 0),
    CONSTRAINT fk_order_detail_order FOREIGN KEY (oID)
        REFERENCES `Order`(oID)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_order_detail_product FOREIGN KEY (pID)
        REFERENCES Product(pID)
        ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- Quan he:
-- Customer 1 -- N Order: khach hang co the chua co hoa don hoac co nhieu hoa don.
-- Order 1 -- N OrderDetail; Product 1 -- N OrderDetail.
-- PK ghep (oID, pID): moi san pham co mot dong trong moi hoa don;
-- odQTY luu so luong duong, co the lon hon 1.
-- oTotalPrice duoc ung dung tinh/cap nhat khi lap hoa don; khong tu cong.
-- Giu nguyen so do: khong them don gia ban lich su vao OrderDetail.

SHOW TABLES;
