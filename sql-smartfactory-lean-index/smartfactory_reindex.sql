-- SmartFactory: thay Fat Covering Index bằng Lean Index
DROP DATABASE IF EXISTS smartfactory_db;
CREATE DATABASE smartfactory_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smartfactory_db;

CREATE TABLE SensorLogs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    recorded_at DATETIME NOT NULL,
    temperature DECIMAL(5, 2),
    humidity DECIMAL(5, 2),
    status VARCHAR(20)
) ENGINE = InnoDB;

-- 100.000 bản ghi minh họa tải ghi của cảm biến.
INSERT INTO SensorLogs (sensor_id, recorded_at, temperature, humidity, status)
SELECT
    MOD(n, 10000) + 1,
    TIMESTAMP('2026-06-01 00:00:00') + INTERVAL MOD(n, 2592000) SECOND,
    18 + MOD(n * 7, 2300) / 100,
    35 + MOD(n * 11, 6000) / 100,
    CASE
        WHEN MOD(n, 100) < 92 THEN 'NORMAL'
        WHEN MOD(n, 100) < 98 THEN 'WARNING'
        ELSE 'CRITICAL'
    END
FROM (
    SELECT
        d0.n + d1.n * 10 + d2.n * 100 + d3.n * 1000 + d4.n * 10000 AS n
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

CREATE INDEX idx_fat_covering
    ON SensorLogs(sensor_id, recorded_at, temperature, humidity, status);

ANALYZE TABLE SensorLogs;
SHOW TABLE STATUS LIKE 'SensorLogs';

SELECT
    ROUND(data_length / 1024 / 1024, 3) AS fat_data_mb,
    ROUND(index_length / 1024 / 1024, 3) AS fat_index_mb
FROM information_schema.TABLES
WHERE table_schema = 'smartfactory_db'
  AND table_name = 'SensorLogs';

EXPLAIN
SELECT temperature, humidity, status
FROM SensorLogs
WHERE sensor_id = 105
  AND recorded_at >= '2026-06-20 00:00:00';

-- Thay index bao phủ bằng index nhỏ chỉ phục vụ lọc và sắp xếp.
ALTER TABLE SensorLogs DROP INDEX idx_fat_covering;
CREATE INDEX idx_lean_search ON SensorLogs(sensor_id, recorded_at);

ANALYZE TABLE SensorLogs;
SHOW TABLE STATUS LIKE 'SensorLogs';

SELECT
    ROUND(data_length / 1024 / 1024, 3) AS lean_data_mb,
    ROUND(index_length / 1024 / 1024, 3) AS lean_index_mb
FROM information_schema.TABLES
WHERE table_schema = 'smartfactory_db'
  AND table_name = 'SensorLogs';

EXPLAIN
SELECT temperature, humidity, status
FROM SensorLogs
WHERE sensor_id = 105
  AND recorded_at >= '2026-06-20 00:00:00';

SHOW INDEX FROM SensorLogs;
