-- Thực hành tham số IN, OUT và INOUT trên classicmodels
USE classicmodels;

DELIMITER //

DROP PROCEDURE IF EXISTS getCusById//
CREATE PROCEDURE getCusById(IN p_customer_number INT)
BEGIN
    SELECT *
    FROM customers
    WHERE customerNumber = p_customer_number;
END//

DROP PROCEDURE IF EXISTS GetCustomersCountByCity//
CREATE PROCEDURE GetCustomersCountByCity(
    IN p_city VARCHAR(50),
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_total
    FROM customers
    WHERE city = p_city;
END//

DROP PROCEDURE IF EXISTS SetCounter//
CREATE PROCEDURE SetCounter(
    INOUT p_counter INT,
    IN p_increment INT
)
BEGIN
    SET p_counter = p_counter + p_increment;
END//

DELIMITER ;

-- Kiểm thử tham số IN.
CALL getCusById(175);

-- Kiểm thử tham số OUT.
CALL GetCustomersCountByCity('Lyon', @total);
SELECT @total AS CustomersInLyon;

-- Kiểm thử tham số INOUT: kết quả cuối cùng là 8.
SET @counter = 1;
CALL SetCounter(@counter, 1);
CALL SetCounter(@counter, 1);
CALL SetCounter(@counter, 5);
SELECT @counter AS FinalCounter;
