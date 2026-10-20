CREATE DATABASE IF NOT EXISTS QuanLySinhVien
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE QuanLySinhVien;

CREATE TABLE IF NOT EXISTS `Class` (
    ClassID INT NOT NULL AUTO_INCREMENT,
    ClassName VARCHAR(60) NOT NULL,
    StartDate DATETIME NOT NULL,
    Status BIT,
    PRIMARY KEY (ClassID)
);

CREATE TABLE IF NOT EXISTS Student (
    StudentID INT NOT NULL AUTO_INCREMENT,
    StudentName VARCHAR(30) NOT NULL,
    Address VARCHAR(50),
    Phone VARCHAR(20),
    Status BIT,
    ClassID INT NOT NULL,
    PRIMARY KEY (StudentID),
    CONSTRAINT fk_student_class
        FOREIGN KEY (ClassID) REFERENCES `Class` (ClassID)
);

CREATE TABLE IF NOT EXISTS Subject (
    SubID INT NOT NULL AUTO_INCREMENT,
    SubName VARCHAR(30) NOT NULL,
    Credit TINYINT NOT NULL DEFAULT 1,
    Status BIT DEFAULT 1,
    PRIMARY KEY (SubID),
    CONSTRAINT chk_subject_credit CHECK (Credit >= 1)
);

CREATE TABLE IF NOT EXISTS Mark (
    MarkID INT NOT NULL AUTO_INCREMENT,
    SubID INT NOT NULL,
    StudentID INT NOT NULL,
    Mark FLOAT DEFAULT 0,
    ExamTimes TINYINT DEFAULT 1,
    PRIMARY KEY (MarkID),
    CONSTRAINT uq_mark_subject_student UNIQUE (SubID, StudentID),
    CONSTRAINT chk_mark_value CHECK (Mark BETWEEN 0 AND 100),
    CONSTRAINT fk_mark_subject
        FOREIGN KEY (SubID) REFERENCES Subject (SubID),
    CONSTRAINT fk_mark_student
        FOREIGN KEY (StudentID) REFERENCES Student (StudentID)
);
