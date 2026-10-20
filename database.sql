CREATE DATABASE IF NOT EXISTS demo; USE demo;
CREATE TABLE IF NOT EXISTS users(id INT NOT NULL AUTO_INCREMENT,name VARCHAR(120) NOT NULL,email VARCHAR(220) NOT NULL,country VARCHAR(120),PRIMARY KEY(id));
INSERT INTO users(name,email,country) VALUES('Minh','minh@codegym.vn','Viet Nam'),('Kante','kante@che.uk','Kenia');
