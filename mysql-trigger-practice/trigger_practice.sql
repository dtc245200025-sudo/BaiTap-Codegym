-- Thực hành Trigger trong MySQL
DROP DATABASE IF EXISTS company;
CREATE DATABASE company CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE company;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL CHECK (salary >= 0)
);

DELIMITER //

CREATE TRIGGER update_department
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary >= 5000 THEN
        SET NEW.department = 'Management';
    ELSEIF NEW.salary >= 3000 THEN
        SET NEW.department = 'Sales';
    ELSE
        SET NEW.department = 'Support';
    END IF;
END//

DELIMITER ;

-- Giá trị department đầu vào sẽ được trigger thay thế theo mức lương.
INSERT INTO employees (name, department, salary) VALUES
    ('John Doe', 'A', 3500),
    ('Jane Smith', 'A', 2000),
    ('David Johnson', 'A', 6000);

SELECT id, name, department, salary
FROM employees
ORDER BY id;

-- Kết quả mong đợi:
-- John Doe     | Sales      | 3500.00
-- Jane Smith   | Support    | 2000.00
-- David Johnson| Management | 6000.00

SHOW TRIGGERS FROM company;
