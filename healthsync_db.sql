-- HEALTHSYNC - BAI THUC HANH NHAT QUAN UML / MYSQL
-- Yeu cau: MySQL >= 8.0.16, InnoDB, tep UTF-8.
-- Cach chay: mo tep trong MySQL Workbench va Execute All tren mot database moi.
-- Hoac trong mysql client: SOURCE C:/duong/dan/healthsync_db.sql;
-- Chay mot lan. Khong co DROP TABLE / DROP DATABASE va khong tu xoa du lieu.
-- Database healthsync_db phai chua co cac bang ben duoi.
-- Neu da co du lieu legacy: sao luu, doi soat va lap bang anh xa trang thai
-- truoc khi ap dung ALTER; KHONG the suy ra 5 trang thai/so tien tu is_active.
-- Phan ALTER o day chuyen doi bang legacy RONG, khong phai migration lich su.
-- So tien: VND. 150000 la phi theo kich ban, khong suy dien ty le phat chung.

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS healthsync_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE healthsync_db;

-- 1. TAO LAI CAU TRUC LEGACY DE BAI CO THE CHAY DOC LAP

CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_appointments_patient FOREIGN KEY (patient_id)
        REFERENCES Patients(patient_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_appointments_doctor FOREIGN KEY (doctor_id)
        REFERENCES Doctors(doctor_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 2. TAI CAU TRUC: BO BOOLEAN, THEM VONG DOI VA DU LIEU TAI CHINH
-- CHECK duoc MySQL thuc thi tu 8.0.16; khong dung MySQL 5.7 cho bai nay.

-- MySQL yeu cau go FK truoc khi doi tinh nullable cua cot dang tham chieu.
-- Thuc hien tren bang rong; tao lai day du FK ngay sau thay doi.
ALTER TABLE Appointments
    DROP FOREIGN KEY fk_appointments_patient,
    DROP FOREIGN KEY fk_appointments_doctor;

ALTER TABLE Appointments
    DROP COLUMN is_active,
    MODIFY COLUMN patient_id INT NOT NULL,
    MODIFY COLUMN doctor_id INT NOT NULL,
    ADD COLUMN status ENUM(
        'PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED'
    ) NOT NULL DEFAULT 'PENDING',
    ADD COLUMN deposit_amount DECIMAL(12,2) NOT NULL,
    ADD COLUMN penalty_fee DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    ADD COLUMN cancel_reason VARCHAR(255) NULL,
    ADD CONSTRAINT fk_appointments_patient FOREIGN KEY (patient_id)
        REFERENCES Patients(patient_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    ADD CONSTRAINT fk_appointments_doctor FOREIGN KEY (doctor_id)
        REFERENCES Doctors(doctor_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    ADD CONSTRAINT ck_appointments_status CHECK (
        status IN ('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED')
    ),
    ADD CONSTRAINT ck_appointments_deposit CHECK (deposit_amount > 0.00),
    ADD CONSTRAINT ck_appointments_penalty CHECK (
        penalty_fee >= 0.00 AND penalty_fee <= deposit_amount
    ),
    ADD CONSTRAINT ck_appointments_cancellation CHECK (
        (status = 'CANCELLED'
            AND cancel_reason IS NOT NULL
            AND CHAR_LENGTH(TRIM(cancel_reason)) > 0)
        OR
        (status <> 'CANCELLED' AND cancel_reason IS NULL AND penalty_fee = 0.00)
    );

-- ERD: Patients 1 -- 0..N Appointments; Doctors 1 -- 0..N Appointments.
--      Appointments 1 -- 0..1 Prescriptions (UNIQUE appointment_id).
-- Moi don thuoc bat buoc thuoc dung 1 lich hen COMPLETED.
-- Nhu cau: sau khi ket thuc giao dich hoan tat kham, lich COMPLETED co 1 don.

CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    medication_details TEXT NOT NULL,
    issued_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_prescriptions_appointment UNIQUE (appointment_id),
    CONSTRAINT fk_prescriptions_appointment FOREIGN KEY (appointment_id)
        REFERENCES Appointments(appointment_id)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_prescriptions_details CHECK (
        CHAR_LENGTH(TRIM(medication_details)) > 0
    )
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- RESTRICT bao ve lien ket ho so; CASCADE se xoa don khi xoa lich hen.
-- FK chi kiem tra lich hen ton tai, khong kiem tra status o bang cha.
-- Trigger ben duoi bo sung rang buoc nghiep vu lien bang.

-- 3. TRIGGER BAO VE VONG DOI VA KE DON
-- Quy uoc huy: PENDING, CONFIRMED, CHECKED_IN deu co the -> CANCELLED.
-- Huy tu PENDING khong bi phat; sau xac nhan, phi do chinh sach ben ngoai
-- cung cap, trong khoang [0, deposit_amount]. Moi lan huy phai co ly do.
-- COMPLETED va CANCELLED la trang thai cuoi, khong duoc chuyen nguoc.
-- Cho INSERT CONFIRMED de phuc vu kich ban 2 (coc da duoc xac nhan).

DELIMITER $$

CREATE TRIGGER trg_appointments_before_insert
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN
    IF NEW.status NOT IN ('PENDING', 'CONFIRMED') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lich hen moi phai la PENDING hoac CONFIRMED.';
    END IF;
END$$

CREATE TRIGGER trg_appointments_before_update
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    IF NEW.status <> OLD.status AND NOT (
        (OLD.status = 'PENDING' AND NEW.status IN ('CONFIRMED', 'CANCELLED'))
        OR (OLD.status = 'CONFIRMED' AND NEW.status IN ('CHECKED_IN', 'CANCELLED'))
        OR (OLD.status = 'CHECKED_IN' AND NEW.status IN ('COMPLETED', 'CANCELLED'))
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Chuyen trang thai lich hen khong hop le.';
    END IF;

    IF OLD.status = 'PENDING' AND NEW.status = 'CANCELLED'
       AND NEW.penalty_fee <> 0.00 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Huy lich PENDING khong duoc tinh phi phat.';
    END IF;
END$$

CREATE TRIGGER trg_prescriptions_before_insert
BEFORE INSERT ON Prescriptions
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_status = NULL;

    SELECT status INTO v_status
    FROM Appointments
    WHERE appointment_id = NEW.appointment_id
    FOR SHARE;

    IF v_status IS NULL OR v_status <> 'COMPLETED' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Chi duoc ke don cho lich hen COMPLETED.';
    END IF;
END$$

CREATE TRIGGER trg_prescriptions_before_update
BEFORE UPDATE ON Prescriptions
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_status = NULL;

    IF NEW.appointment_id <> OLD.appointment_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Khong duoc chuyen don thuoc sang lich hen khac.';
    END IF;

    SELECT status INTO v_status
    FROM Appointments
    WHERE appointment_id = NEW.appointment_id
    FOR SHARE;

    IF v_status IS NULL OR v_status <> 'COMPLETED' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Don thuoc phai thuoc lich hen COMPLETED.';
    END IF;
END$$

DELIMITER ;

-- 4. DU LIEU MO PHONG: DUNG LAST_INSERT_ID(), KHONG GIA DINH ID CO DINH
-- Du lieu ten, dien thoai va don thuoc duoi day deu la du lieu gia lap.
-- DDL o tren tu commit; START TRANSACTION chi bao ve phan DML sau day.

START TRANSACTION;

INSERT INTO Patients (full_name, phone)
VALUES ('Nguyễn Minh An', '0900000001');
SET @patient_success = LAST_INSERT_ID();

INSERT INTO Patients (full_name, phone)
VALUES ('Trần Thu Bình', '0900000002');
SET @patient_cancel = LAST_INSERT_ID();

INSERT INTO Doctors (full_name, specialty)
VALUES ('Lê Hoàng Nam', 'Nội tổng quát');
SET @doctor_demo = LAST_INSERT_ID();

-- Kich ban 1: coc 500.000d; them CONFIRMED de khop mo ta Activity Diagram.
INSERT INTO Appointments (
    patient_id, doctor_id, appointment_date, status, deposit_amount
) VALUES (
    @patient_success, @doctor_demo, '2026-10-19 08:30:00', 'PENDING', 500000.00
);
SET @appointment_success = LAST_INSERT_ID();

UPDATE Appointments SET status = 'CONFIRMED'
WHERE appointment_id = @appointment_success;

UPDATE Appointments SET status = 'CHECKED_IN'
WHERE appointment_id = @appointment_success;

UPDATE Appointments SET status = 'COMPLETED'
WHERE appointment_id = @appointment_success;

INSERT INTO Prescriptions (appointment_id, medication_details, issued_date)
VALUES (
    @appointment_success,
    'Đơn thuốc mô phỏng: Thuốc A; hướng dẫn sử dụng theo chỉ định bác sĩ.',
    '2026-10-19 09:00:00'
);

-- Kich ban 2: coc 300.000d, huy voi phi phat 150.000d.
INSERT INTO Appointments (
    patient_id, doctor_id, appointment_date, status, deposit_amount
) VALUES (
    @patient_cancel, @doctor_demo, '2026-10-19 10:00:00', 'CONFIRMED', 300000.00
);
SET @appointment_cancel = LAST_INSERT_ID();

UPDATE Appointments
SET status = 'CANCELLED',
    cancel_reason = 'Bận việc đột xuất',
    penalty_fee = 150000.00
WHERE appointment_id = @appointment_cancel;

COMMIT;

-- Khi ung dung gap loi trong giao dich: ROLLBACK, khong COMMIT phan con lai.
-- FK + UNIQUE bao dam toi da 1 don, khong tu bat buoc moi COMPLETED phai co don.
-- Mau DML cap nhat COMPLETED va INSERT don trong cung giao dich.
-- Neu can bat buoc voi moi client: dong goi trong stored procedure va chi cap
-- quyen EXECUTE, thu hoi quyen ghi truc tiep; day la huong mo rong ngoai bai.

-- 5. TRUY VAN MINH CHUNG

-- 5.1 Ca hai lich hen: giu nguyen coc goc; phi phat luu rieng.
SELECT a.appointment_id, p.full_name AS patient_name, d.full_name AS doctor_name,
       a.status, a.deposit_amount, a.penalty_fee, a.cancel_reason
FROM Appointments AS a
JOIN Patients AS p ON p.patient_id = a.patient_id
JOIN Doctors AS d ON d.doctor_id = a.doctor_id
ORDER BY a.appointment_id;
-- Du kien: An | COMPLETED | 500000.00 | 0.00 | NULL
--          Binh | CANCELLED | 300000.00 | 150000.00 | Ban viec dot xuat

-- 5.2 Benh nhan da kham xong va chi tiet don thuoc (1 dong).
SELECT p.full_name AS patient_name, a.appointment_id, a.appointment_date,
       d.full_name AS doctor_name, pr.prescription_id,
       pr.medication_details, pr.issued_date
FROM Appointments AS a
JOIN Patients AS p ON p.patient_id = a.patient_id
JOIN Doctors AS d ON d.doctor_id = a.doctor_id
JOIN Prescriptions AS pr ON pr.appointment_id = a.appointment_id
WHERE a.status = 'COMPLETED'
ORDER BY a.appointment_id;

-- 5.3 Doi soat lich huy: so tien PHAI HOAN, khong phai chung tu da hoan tien.
SELECT a.appointment_id, p.full_name AS patient_name, a.deposit_amount,
       a.penalty_fee, a.deposit_amount - a.penalty_fee AS refund_due,
       a.cancel_reason
FROM Appointments AS a
JOIN Patients AS p ON p.patient_id = a.patient_id
WHERE a.status = 'CANCELLED';
-- Du kien: coc 300000.00; phi 150000.00; phai hoan 150000.00.

SELECT COALESCE(SUM(deposit_amount), 0.00) AS cancelled_deposits,
       COALESCE(SUM(penalty_fee), 0.00) AS total_penalty,
       COALESCE(SUM(deposit_amount - penalty_fee), 0.00) AS total_refund_due
FROM Appointments
WHERE status = 'CANCELLED';
-- Khong coi toan bo tien coc la doanh thu kham; bai chua co hoa don/so quy.

-- 5.4 Tu doi chieu hai kich ban: ca hai dong phai la PASS.
SELECT 'Kich ban 1: kham va ke don' AS test_case,
       IF(COUNT(*) = 1, 'PASS', 'FAIL') AS result
FROM Appointments AS a
JOIN Prescriptions AS pr ON pr.appointment_id = a.appointment_id
WHERE a.appointment_id = @appointment_success
  AND a.status = 'COMPLETED'
  AND a.deposit_amount = 500000.00 AND a.penalty_fee = 0.00
UNION ALL
SELECT 'Kich ban 2: huy va phat', IF(COUNT(*) = 1, 'PASS', 'FAIL')
FROM Appointments AS a
WHERE a.appointment_id = @appointment_cancel
  AND a.status = 'CANCELLED'
  AND a.deposit_amount = 300000.00 AND a.penalty_fee = 150000.00
  AND a.deposit_amount - a.penalty_fee = 150000.00
  AND a.cancel_reason = 'Bận việc đột xuất'
  AND NOT EXISTS (
      SELECT 1 FROM Prescriptions AS pr
      WHERE pr.appointment_id = a.appointment_id
  );

-- 5.5 Phat hien COMPLETED thieu don / lich chua hoan tat lai co don.
-- Sau hai kich ban hop le, truy van nay phai tra ve 0 dong.
SELECT a.appointment_id, a.status, pr.prescription_id
FROM Appointments AS a
LEFT JOIN Prescriptions AS pr ON pr.appointment_id = a.appointment_id
WHERE (a.status = 'COMPLETED' AND pr.prescription_id IS NULL)
   OR (a.status <> 'COMPLETED' AND pr.prescription_id IS NOT NULL);

-- 6. KIEM THU AM: BO COMMENT VA CHAY TUNG LENH RIENG SAU SCRIPT.
-- Cac lenh nay CO CHU DICH gay loi; khong dua vao luong chay thanh cong.

-- 6.1 Tao lich PENDING tam trong giao dich, thu ke don va mong loi 1644.
-- START TRANSACTION;
-- INSERT INTO Appointments
--     (patient_id, doctor_id, appointment_date, deposit_amount)
-- VALUES (@patient_success, @doctor_demo, '2026-10-20 08:00:00', 200000.00);
-- SET @appointment_pending_test = LAST_INSERT_ID();
-- INSERT INTO Prescriptions (appointment_id, medication_details)
-- VALUES (@appointment_pending_test, 'Don khong hop le');
-- ROLLBACK; -- Phai thuc hien ca khi INSERT tren bi loi.

-- 6.2 Don thu hai cung lich: loi duplicate key (1062).
-- INSERT INTO Prescriptions (appointment_id, medication_details)
-- VALUES (@appointment_success, 'Don trung');

-- 6.3 Phi phat vuot coc: loi CHECK (3819).
-- UPDATE Appointments SET penalty_fee = 400000.00
-- WHERE appointment_id = @appointment_cancel;

-- 6.4 Xoa ly do huy: loi CHECK (3819).
-- UPDATE Appointments SET cancel_reason = NULL
-- WHERE appointment_id = @appointment_cancel;

-- 6.5 Dao nguoc trang thai cuoi: loi trigger (1644).
-- UPDATE Appointments SET status = 'PENDING'
-- WHERE appointment_id = @appointment_success;

-- 6.6 Xoa lich da co don: loi FK RESTRICT (1451).
-- DELETE FROM Appointments WHERE appointment_id = @appointment_success;

-- Tai lieu: https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html
-- https://dev.mysql.com/doc/refman/8.4/en/create-table-foreign-keys.html
-- https://dev.mysql.com/doc/refman/8.4/en/create-trigger.html
-- https://dev.mysql.com/doc/refman/8.4/en/precision-math-numbers.html
