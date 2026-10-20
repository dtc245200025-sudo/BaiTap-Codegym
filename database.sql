CREATE DATABASE IF NOT EXISTS demo; USE demo;
CREATE TABLE IF NOT EXISTS users(id INT NOT NULL AUTO_INCREMENT,name VARCHAR(120) NOT NULL,email VARCHAR(220) NOT NULL,country VARCHAR(120),PRIMARY KEY(id));
INSERT INTO users(name,email,country) VALUES('Minh','minh@codegym.vn','Viet Nam'),('Kante','kante@che.uk','Kenia');
CREATE TABLE IF NOT EXISTS Employee(id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(120) NOT NULL,salary DECIMAL(15,2) NOT NULL,created_Date DATETIME);
DELIMITER //
CREATE PROCEDURE get_users() BEGIN SELECT * FROM users ORDER BY id; END //
CREATE PROCEDURE update_user(IN p_id INT,IN p_name VARCHAR(120),IN p_email VARCHAR(220),IN p_country VARCHAR(120)) BEGIN UPDATE users SET name=p_name,email=p_email,country=p_country WHERE id=p_id; END //
CREATE PROCEDURE delete_user(IN p_id INT) BEGIN DELETE FROM users WHERE id=p_id; END //
DELIMITER ;
