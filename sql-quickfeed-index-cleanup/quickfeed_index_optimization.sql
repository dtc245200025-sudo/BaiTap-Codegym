-- QuickFeed: đo lường và loại bỏ index dư thừa
DROP DATABASE IF EXISTS quickfeed_db;
CREATE DATABASE quickfeed_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE quickfeed_db;

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    post_type VARCHAR(10),
    is_visible BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;

-- Tạo 10.000 bản ghi để phép đo index có dữ liệu thực.
INSERT INTO Posts (user_id, content, post_type, is_visible, created_at)
SELECT
    MOD(n, 1000) + 1,
    CONCAT('QuickFeed post ', n, ' - sample content for storage measurement'),
    CASE MOD(n, 3) WHEN 0 THEN 'TEXT' WHEN 1 THEN 'IMAGE' ELSE 'VIDEO' END,
    IF(MOD(n, 100) = 0, FALSE, TRUE),
    TIMESTAMP('2026-01-01 00:00:00') + INTERVAL MOD(n, 86400) SECOND
FROM (
    SELECT d0.n + d1.n * 10 + d2.n * 100 + d3.n * 1000 AS n
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
) AS numbers;

-- Trạng thái over-indexing ban đầu.
CREATE INDEX idx_user_id ON Posts(user_id);
CREATE INDEX idx_content ON Posts(content(255));
CREATE INDEX idx_post_type ON Posts(post_type);
CREATE INDEX idx_is_visible ON Posts(is_visible);
CREATE INDEX idx_created_at ON Posts(created_at);

ANALYZE TABLE Posts;
SHOW TABLE STATUS LIKE 'Posts';

CREATE TABLE StorageAudit (
    stage VARCHAR(20) PRIMARY KEY,
    data_mb DECIMAL(12, 3),
    index_mb DECIMAL(12, 3),
    measured_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO StorageAudit (stage, data_mb, index_mb)
SELECT
    'before_cleanup',
    ROUND(data_length / 1024 / 1024, 3),
    ROUND(index_length / 1024 / 1024, 3)
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db'
  AND table_name = 'Posts';

-- Giữ idx_user_id và idx_created_at; xóa ba index ít giá trị.
ALTER TABLE Posts DROP INDEX idx_content;
ALTER TABLE Posts DROP INDEX idx_post_type;
ALTER TABLE Posts DROP INDEX idx_is_visible;

ANALYZE TABLE Posts;
SHOW TABLE STATUS LIKE 'Posts';

INSERT INTO StorageAudit (stage, data_mb, index_mb)
SELECT
    'after_cleanup',
    ROUND(data_length / 1024 / 1024, 3),
    ROUND(index_length / 1024 / 1024, 3)
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db'
  AND table_name = 'Posts';

-- Bảng so sánh số MB trước/sau và dung lượng index đã giải phóng.
SELECT
    before_row.data_mb AS data_mb_before,
    before_row.index_mb AS index_mb_before,
    after_row.data_mb AS data_mb_after,
    after_row.index_mb AS index_mb_after,
    ROUND(before_row.index_mb - after_row.index_mb, 3) AS index_mb_released
FROM StorageAudit AS before_row
JOIN StorageAudit AS after_row
WHERE before_row.stage = 'before_cleanup'
  AND after_row.stage = 'after_cleanup';

SHOW INDEX FROM Posts;
