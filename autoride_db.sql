-- AUTORIDE: DDL + ALTER TABLE + DML + TRUY VAN KIEM CHUNG
-- MySQL >= 8.0.16; InnoDB; UTF-8. Chay mot lan tren CSDL chua co cac bang nay.
-- Khong DROP bang/du lieu. DDL tu commit, khong rollback cung giao dich DML.
-- ALTER duoi day ap dung tren bang legacy RONG do script vua tao.
-- Neu nang cap du lieu that: backup, doi soat status, coc va han tra truoc;
-- khong gan coc=0 hay tu suy dien thong tin tai chinh lich su bi thieu.

SET NAMES utf8mb4;
CREATE DATABASE IF NOT EXISTS autoride_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE autoride_db;

-- 1. KHOI TAO CAU TRUC LEGACY
CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME,
    status VARCHAR(50) DEFAULT 'BOOKED',
    CONSTRAINT fk_rentals_car FOREIGN KEY (car_id)
        REFERENCES Cars(car_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. NANG CAP RENTALS BANG ALTER TABLE
-- return_date = thoi diem tra THUC TE; due_date = han tra theo hop dong.
-- due_date duoc bo sung de nhan biet/tinh tre han, thay vi suy doan.
-- Go FK truoc khi doi car_id thanh NOT NULL, roi tao lai ngay trong ALTER.
ALTER TABLE Rentals DROP FOREIGN KEY fk_rentals_car;

ALTER TABLE Rentals
    MODIFY COLUMN car_id INT NOT NULL,
    MODIFY COLUMN status ENUM('BOOKED','ACTIVE','COMPLETED','CANCELLED')
        NOT NULL DEFAULT 'BOOKED',
    ADD COLUMN due_date DATETIME NOT NULL,
    ADD COLUMN security_deposit DECIMAL(12,2) NOT NULL,
    ADD COLUMN late_fee DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    ADD COLUMN damage_fee DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    ADD CONSTRAINT fk_rentals_car FOREIGN KEY (car_id)
        REFERENCES Cars(car_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    ADD CONSTRAINT ck_rentals_status CHECK (
        status IN ('BOOKED','ACTIVE','COMPLETED','CANCELLED')
    ),
    ADD CONSTRAINT ck_rentals_dates CHECK (due_date >= rent_date),
    ADD CONSTRAINT ck_rentals_deposit CHECK (security_deposit > 0),
    ADD CONSTRAINT ck_rentals_fees CHECK (late_fee >= 0 AND damage_fee >= 0),
    ADD CONSTRAINT ck_rentals_completion CHECK (
        (status = 'COMPLETED' AND return_date IS NOT NULL AND return_date >= rent_date)
        OR (status <> 'COMPLETED' AND return_date IS NULL AND late_fee = 0 AND damage_fee = 0)
    );

-- Khong chan tong phi vuot coc: khi do khach con phai nop them.
-- Khong luu refund thanh cot nhap tay, tranh lech cong thuc tinh tien.

-- 3. ERD: Cars 1 -- N Rentals; Rentals 1 -- N Inspections.
-- Luc BOOKED chua co inspection. Chon 1-N de luu nhieu lan kiem tra
-- trong giai doan ACTIVE; moi ban ghi thuoc duy nhat mot hop dong.
-- Phi tong hop cua hop dong luu o Rentals, khong cong lap theo so bien ban.
CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    CONSTRAINT fk_inspections_rental FOREIGN KEY (rental_id)
        REFERENCES Rentals(rental_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_inspections_inspector CHECK (
        CHAR_LENGTH(TRIM(inspector_name)) > 0
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. BAO VE QUY TRINH TAI DATABASE
-- BOOKED -> ACTIVE -> COMPLETED; BOOKED -> CANCELLED.
-- De bai chua neu huy khi da nhan xe; mau nay khong cho ACTIVE -> CANCELLED.
-- Chi ghi/sua inspection khi ACTIVE. COMPLETED phai co bien ban tra xe;
-- neu damage_fee > 0 thi bien ban phai co mo ta hu hong.

DELIMITER $$

CREATE TRIGGER trg_rentals_insert
BEFORE INSERT ON Rentals FOR EACH ROW
BEGIN
    IF NEW.status <> 'BOOKED' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hop dong moi phai la BOOKED.';
    END IF;
END$$

CREATE TRIGGER trg_rentals_update
BEFORE UPDATE ON Rentals FOR EACH ROW
BEGIN
    DECLARE v_inspection_id INT DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_inspection_id = NULL;

    IF OLD.status IN ('COMPLETED','CANCELLED') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Khong sua hop dong da ket thuc.';
    END IF;

    IF NEW.status <> OLD.status AND NOT (
        (OLD.status = 'BOOKED' AND NEW.status IN ('ACTIVE','CANCELLED'))
        OR (OLD.status = 'ACTIVE' AND NEW.status = 'COMPLETED')
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Chuyen trang thai khong hop le.';
    END IF;

    IF NEW.status = 'COMPLETED' THEN
        -- Doc co khoa de xac nhan bien ban moi nhat da duoc ghi nhan.
        SELECT inspection_id INTO v_inspection_id
        FROM Inspections
        WHERE rental_id = OLD.rental_id
          AND inspection_date >= NEW.return_date
          AND (NEW.damage_fee = 0 OR (
              damage_description IS NOT NULL
              AND CHAR_LENGTH(TRIM(damage_description)) > 0
          ))
        ORDER BY inspection_id DESC LIMIT 1 FOR SHARE;

        IF v_inspection_id IS NULL THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Can bien ban tra xe; phi hu hong phai co mo ta.';
        END IF;
        IF NEW.late_fee > 0 AND NEW.return_date <= NEW.due_date THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Khong tinh phi tre khi tra dung han.';
        END IF;
    END IF;
END$$

CREATE TRIGGER trg_inspections_insert
BEFORE INSERT ON Inspections FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_rent_date DATETIME DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_status = NULL;
    SELECT status, rent_date INTO v_status, v_rent_date
    FROM Rentals WHERE rental_id = NEW.rental_id FOR SHARE;
    IF v_status IS NULL OR v_status <> 'ACTIVE' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Chi kiem tra hop dong ACTIVE.';
    END IF;
    IF NEW.inspection_date < v_rent_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kiem tra khong duoc truoc luc thue.';
    END IF;
END$$

CREATE TRIGGER trg_inspections_update
BEFORE UPDATE ON Inspections FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_rent_date DATETIME DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_status = NULL;
    IF NEW.rental_id <> OLD.rental_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Khong chuyen bien ban sang hop dong khac.';
    END IF;
    SELECT status, rent_date INTO v_status, v_rent_date
    FROM Rentals WHERE rental_id = NEW.rental_id FOR SHARE;
    IF v_status IS NULL OR v_status <> 'ACTIVE' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Chi sua bien ban khi hop dong ACTIVE.';
    END IF;
    IF NEW.inspection_date < v_rent_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kiem tra khong duoc truoc luc thue.';
    END IF;
END$$

CREATE TRIGGER trg_inspections_delete
BEFORE DELETE ON Inspections FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    SELECT status INTO v_status
    FROM Rentals WHERE rental_id = OLD.rental_id FOR SHARE;
    IF v_status = 'COMPLETED' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Khong xoa bien ban hop dong COMPLETED.';
    END IF;
END$$

DELIMITER ;

-- 5. KICH BAN BAT BUOC: COC 10 TRIEU, VO DEN PHA, PHI 2 TRIEU
-- Giao dich phai ROLLBACK neu bat ky buoc ghi du lieu nao that bai.
START TRANSACTION;
INSERT INTO Cars(model_name, license_plate)
VALUES ('Toyota Vios', '30A-123.45');
SET @car_demo = LAST_INSERT_ID();

INSERT INTO Rentals(car_id, customer_name, rent_date, due_date, security_deposit)
VALUES (@car_demo, 'Nguyen Van A', '2026-10-01 08:00:00', '2026-10-03 08:00:00', 10000000.00);
SET @rental_a = LAST_INSERT_ID();

UPDATE Rentals SET status = 'ACTIVE' WHERE rental_id = @rental_a;

INSERT INTO Inspections(rental_id, inspection_date, damage_description, inspector_name)
VALUES (@rental_a, '2026-10-03 08:10:00', 'Vỡ đèn pha trái', 'Tran Thi B');

UPDATE Rentals
SET return_date = '2026-10-03 08:00:00', status = 'COMPLETED',
    late_fee = 0.00, damage_fee = 2000000.00
WHERE rental_id = @rental_a;
COMMIT;

-- 6. CA BO SUNG CHO VAN DAP: TRE DUNG 2 NGAY VA VO DEN PHA
-- Gia dinh MINH HOA: 500.000 VND/moi ngay tre, lam tron len ngay le.
-- Day KHONG phai muc phi de bai quy dinh; thuc te phai lay tu hop dong.
SET @daily_late_rate = 500000.00;
START TRANSACTION;
INSERT INTO Rentals(car_id, customer_name, rent_date, due_date, security_deposit)
VALUES (@car_demo, 'Nguyen Van C', '2026-10-04 08:00:00', '2026-10-06 08:00:00', 10000000.00);
SET @rental_late = LAST_INSERT_ID();

UPDATE Rentals SET status = 'ACTIVE' WHERE rental_id = @rental_late;
INSERT INTO Inspections(rental_id, inspection_date, damage_description, inspector_name)
VALUES (@rental_late, '2026-10-08 08:10:00', 'Vỡ đèn pha trái', 'Tran Thi B');

UPDATE Rentals
SET return_date = '2026-10-08 08:00:00',
    late_fee = CEILING(GREATEST(0, TIMESTAMPDIFF(SECOND, due_date, '2026-10-08 08:00:00')) / 86400) * @daily_late_rate,
    damage_fee = 2000000.00, status = 'COMPLETED'
WHERE rental_id = @rental_late;
COMMIT;

-- 7. TRUY VAN MINH CHUNG
SELECT rental_id, customer_name, status, security_deposit, late_fee, damage_fee,
       security_deposit - late_fee - damage_fee AS refund_amount
FROM Rentals WHERE status = 'COMPLETED' ORDER BY rental_id;
-- Nguyen Van A: 10000000 - 0 - 2000000 = 8000000.00 VND.
-- Nguyen Van C: 10000000 - 1000000 - 2000000 = 7000000.00 VND.

-- Neu tong phi vuot coc: balance am la khoan con thieu, khong hoan tien am.
SELECT rental_id,
       security_deposit - late_fee - damage_fee AS deposit_balance,
       GREATEST(0.00, security_deposit - late_fee - damage_fee) AS refund_due,
       GREATEST(0.00, late_fee + damage_fee - security_deposit) AS extra_due
FROM Rentals WHERE status = 'COMPLETED' ORDER BY rental_id;
-- refund_due la so PHAI HOAN, khong phai bang chung da chuyen tien.

SELECT r.rental_id, r.customer_name, i.inspection_date,
       i.damage_description, i.inspector_name
FROM Rentals AS r
JOIN Inspections AS i ON i.rental_id = r.rental_id
ORDER BY r.rental_id, i.inspection_id;

-- Kiem tra tong hop: khong JOIN Inspections de tranh nhan doi phi khi co nhieu bien ban.
SELECT IF(COUNT(*) = 1, 'PASS', 'FAIL') AS required_scenario
FROM Rentals
WHERE rental_id = @rental_a AND status = 'COMPLETED'
  AND security_deposit = 10000000.00 AND late_fee = 0.00
  AND damage_fee = 2000000.00
  AND security_deposit - late_fee - damage_fee = 8000000.00;

-- Tai lieu MySQL:
-- https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html
-- https://dev.mysql.com/doc/refman/8.4/en/create-trigger.html
-- https://dev.mysql.com/doc/refman/8.4/en/create-table-foreign-keys.html
-- https://dev.mysql.com/doc/refman/8.4/en/precision-math-numbers.html
