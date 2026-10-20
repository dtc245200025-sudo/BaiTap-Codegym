USE QuanLySinhVien;

-- 1. Sinh viên có tên bắt đầu bằng chữ H.
SELECT
    StudentID,
    StudentName,
    Address,
    Phone,
    Status,
    ClassID
FROM Student
WHERE StudentName LIKE 'H%'
ORDER BY StudentName;

-- 2. Lớp học bắt đầu trong tháng 12.
SELECT
    ClassID,
    ClassName,
    StartDate,
    Status
FROM `Class`
WHERE MONTH(StartDate) = 12
ORDER BY StartDate;

-- 3. Môn học có credit từ 3 đến 5, tính cả hai đầu mút.
SELECT
    SubID,
    SubName,
    Credit,
    Status
FROM Subject
WHERE Credit BETWEEN 3 AND 5
ORDER BY Credit, SubName;

-- 4. Chuyển sinh viên Hung sang lớp có ClassID = 2.
START TRANSACTION;

UPDATE Student
SET ClassID = 2
WHERE StudentName = 'Hung';

COMMIT;

-- Kiểm tra kết quả cập nhật.
SELECT StudentID, StudentName, ClassID
FROM Student
WHERE StudentName = 'Hung';

-- 5. Hiển thị tên sinh viên, tên môn và điểm.
-- Điểm giảm dần; nếu bằng điểm thì tên sinh viên tăng dần.
SELECT
    s.StudentName,
    sub.SubName,
    m.Mark
FROM Mark AS m
JOIN Student AS s ON s.StudentID = m.StudentID
JOIN Subject AS sub ON sub.SubID = m.SubID
ORDER BY m.Mark DESC, s.StudentName ASC;
