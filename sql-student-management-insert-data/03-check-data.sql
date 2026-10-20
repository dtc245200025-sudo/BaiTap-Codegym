USE QuanLySinhVien;

SELECT ClassID, ClassName, StartDate, Status
FROM `Class`
ORDER BY ClassID;

SELECT StudentID, StudentName, Address, Phone, Status, ClassID
FROM Student
ORDER BY StudentID;

SELECT SubID, SubName, Credit, Status
FROM Subject
ORDER BY SubID;

SELECT MarkID, SubID, StudentID, Mark, ExamTimes
FROM Mark
ORDER BY MarkID;

SELECT
    st.StudentName,
    c.ClassName,
    su.SubName,
    m.Mark,
    m.ExamTimes
FROM Mark AS m
JOIN Student AS st ON st.StudentID = m.StudentID
JOIN `Class` AS c ON c.ClassID = st.ClassID
JOIN Subject AS su ON su.SubID = m.SubID
ORDER BY m.MarkID;
