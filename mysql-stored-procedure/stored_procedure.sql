-- Thực hành Stored Procedure trên classicmodels
USE classicmodels;

DELIMITER //

DROP PROCEDURE IF EXISTS findAllCustomers//

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT *
    FROM customers
    ORDER BY customerNumber;
END//

DELIMITER ;

CALL findAllCustomers();

-- MySQL không sửa trực tiếp phần thân procedure; cần DROP rồi CREATE lại.
DELIMITER //

DROP PROCEDURE IF EXISTS findAllCustomers//

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT *
    FROM customers
    WHERE customerNumber = 175;
END//

DELIMITER ;

CALL findAllCustomers();

SHOW CREATE PROCEDURE findAllCustomers;
