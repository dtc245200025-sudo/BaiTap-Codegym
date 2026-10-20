USE QuanLySinhVien;

-- 1. Hiển thị danh sách tất cả học viên.
SELECT
    StudentID,
    StudentName,
    Address,
    Phone,
    Status,
    ClassID
FROM Student
ORDER BY StudentID;

-- 2. Hiển thị danh sách học viên đang theo học.
SELECT
    StudentID,
    StudentName,
    Address,
    Phone,
    ClassID
FROM Student
WHERE Status = 1
ORDER BY StudentID;

-- 3. Hiển thị các môn học có thời lượng/tín chỉ nhỏ hơn 10.
SELECT
    SubID,
    SubName,
    Credit,
    Status
FROM Subject
WHERE Credit < 10
ORDER BY SubID;

-- 4. Hiển thị danh sách học viên lớp A1.
SELECT
    s.StudentID,
    s.StudentName,
    c.ClassName
FROM Student AS s
JOIN `Class` AS c ON c.ClassID = s.ClassID
WHERE c.ClassName = 'A1'
ORDER BY s.StudentID;

-- 5. Hiển thị điểm môn CF của các học viên.
SELECT
    s.StudentID,
    s.StudentName,
    sub.SubName,
    m.Mark,
    m.ExamTimes
FROM Mark AS m
JOIN Student AS s ON s.StudentID = m.StudentID
JOIN Subject AS sub ON sub.SubID = m.SubID
WHERE sub.SubName = 'CF'
ORDER BY s.StudentID;
