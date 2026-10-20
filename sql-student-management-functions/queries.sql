-- Bài tập: Luyện tập các hàm thông dụng trong SQL
USE QuanLySinhVien;

-- 1. Tất cả môn học đồng hạng có số tín chỉ lớn nhất.
SELECT
    sub.SubId,
    sub.SubName,
    sub.Credit,
    sub.Status
FROM Subject AS sub
WHERE sub.Credit = (
    SELECT MAX(Credit)
    FROM Subject
)
ORDER BY sub.SubId;

-- 2. Thông tin các môn học có điểm thi lớn nhất toàn hệ thống.
-- DISTINCT tránh lặp môn học nếu nhiều sinh viên cùng đạt điểm cao nhất.
SELECT DISTINCT
    sub.SubId,
    sub.SubName,
    sub.Credit,
    sub.Status,
    m.Mark AS HighestMark
FROM Subject AS sub
JOIN Mark AS m ON m.SubId = sub.SubId
WHERE m.Mark = (
    SELECT MAX(Mark)
    FROM Mark
)
ORDER BY sub.SubId;

-- 3. Sinh viên và điểm trung bình, xếp hạng giảm dần.
SELECT
    s.StudentId,
    s.StudentName,
    s.Address,
    s.Phone,
    s.Status,
    s.ClassId,
    AVG(m.Mark) AS AverageMark
FROM Student AS s
JOIN Mark AS m ON m.StudentId = s.StudentId
GROUP BY
    s.StudentId,
    s.StudentName,
    s.Address,
    s.Phone,
    s.Status,
    s.ClassId
ORDER BY AverageMark DESC, s.StudentName ASC;
