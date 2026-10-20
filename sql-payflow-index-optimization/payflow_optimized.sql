-- Bài tập: Tối ưu báo cáo PayFlow bằng EXPLAIN và Index
DROP DATABASE IF EXISTS payflow_db;
CREATE DATABASE payflow_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE payflow_db;

CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    created_at DATETIME NOT NULL
);

-- Sinh 100.000 giao dịch để có thể quan sát rõ sự khác biệt trong EXPLAIN.
INSERT INTO Transactions (user_id, amount, transaction_type, created_at)
SELECT
    MOD(numbers.n, 1000) + 1,
    MOD(numbers.n * 137, 100000) / 100 + 10,
    CASE MOD(numbers.n, 3)
        WHEN 0 THEN 'DEPOSIT'
        WHEN 1 THEN 'WITHDRAW'
        ELSE 'TRANSFER'
    END,
    TIMESTAMP('2025-01-01 00:00:00')
        + INTERVAL MOD(numbers.n, 730) DAY
        + INTERVAL MOD(numbers.n * 97, 86400) SECOND
FROM (
    SELECT
        d0.n
        + d1.n * 10
        + d2.n * 100
        + d3.n * 1000
        + d4.n * 10000 AS n
    FROM
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d0
    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d1
    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d2
    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d3
    CROSS JOIN
        (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d4
) AS numbers;

ANALYZE TABLE Transactions;

-- Truy vấn cũ: YEAR() và MONTH() bọc cột created_at nên không SARGable.
EXPLAIN
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND YEAR(created_at) = 2026
  AND MONTH(created_at) = 6;

-- Composite index: điều kiện bằng (=) đứng trước, điều kiện khoảng đứng sau.
CREATE INDEX idx_type_date
    ON Transactions(transaction_type, created_at);

ANALYZE TABLE Transactions;

-- Truy vấn tối ưu: khoảng nửa kín [đầu tháng, đầu tháng sau).
EXPLAIN
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND created_at >= '2026-06-01 00:00:00'
  AND created_at <  '2026-07-01 00:00:00';

-- Chạy báo cáo thật sau khi kiểm tra kế hoạch thực thi.
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND created_at >= '2026-06-01 00:00:00'
  AND created_at <  '2026-07-01 00:00:00';

-- MySQL 8.0.18+: đo thời gian thực thi thực tế nếu cần.
EXPLAIN ANALYZE
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND created_at >= '2026-06-01 00:00:00'
  AND created_at <  '2026-07-01 00:00:00';
