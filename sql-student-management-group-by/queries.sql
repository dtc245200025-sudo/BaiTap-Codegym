-- Thực hành: Sử dụng các hàm thông dụng và GROUP BY
USE QuanLySinhVien;

-- 1. Số lượng sinh viên ở từng nơi.
SELECT
    Address,
    COUNT(StudentId) AS StudentCount
FROM Student
GROUP BY Address
ORDER BY Address;

-- 2. Điểm trung bình các môn học của mỗi học viên.
SELECT
    s.StudentId,
    s.StudentName,
    AVG(m.Mark) AS AverageMark
FROM Student AS s
JOIN Mark AS m ON m.StudentId = s.StudentId
GROUP BY s.StudentId, s.StudentName
ORDER BY s.StudentId;

-- 3. Học viên có điểm trung bình lớn hơn 15.
SELECT
    s.StudentId,
    s.StudentName,
    AVG(m.Mark) AS AverageMark
FROM Student AS s
JOIN Mark AS m ON m.StudentId = s.StudentId
GROUP BY s.StudentId, s.StudentName
HAVING AVG(m.Mark) > 15
ORDER BY AverageMark DESC, s.StudentName ASC;

-- 4. Tất cả học viên đồng hạng ở mức điểm trung bình lớn nhất.
SELECT
    s.StudentId,
    s.StudentName,
    AVG(m.Mark) AS AverageMark
FROM Student AS s
JOIN Mark AS m ON m.StudentId = s.StudentId
GROUP BY s.StudentId, s.StudentName
HAVING AVG(m.Mark) >= ALL (
    SELECT AVG(m2.Mark)
    FROM Mark AS m2
    GROUP BY m2.StudentId
)
ORDER BY s.StudentName;
