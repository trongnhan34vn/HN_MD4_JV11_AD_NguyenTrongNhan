CREATE DATABASE Test2;
USE Test2;

CREATE TABLE Students
(
	StudentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentName	VARCHAR(50) NOT NULL,
    Age INT,
    Email VARCHAR(100)
);

CREATE TABLE Classes
(
	ClassID INT PRIMARY KEY AUTO_INCREMENT,
    ClassName VARCHAR(50) NOT NULL
);

CREATE TABLE ClassStudent
(
	StudentID INT,
    ClassID INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
);

CREATE TABLE Subjects
(
	SubjectID INT PRIMARY KEY AUTO_INCREMENT,
    SubjectName VARCHAR(50) NOT NULL
);

CREATE TABLE Marks
(
	Mark INT,
    SubjectID INT,
    StudentID INT,
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

INSERT INTO Students (StudentName, Age, Email) VALUES
("Nguyen Quang An", 18, "an@yahoo.com"),
("Nguyen Cong Vinh", 20, "vinh@gmail.com"),
("Nguyen Van Quyen", 19, "quyen"),
("Pham Thanh Binh", 25, "binh@com"),
("Nguyen Van Tai Em", 30, "taiem@sport.vn");

INSERT INTO Classes (ClassName) VALUES
("C0706L"),
("C0708G");

INSERT INTO ClassStudent VALUES 
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 2);

INSERT INTO Subjects (SubjectName) VALUES
("SQL"),
("Java"),
("C"),
("Visual Basic");

INSERT INTO Marks VALUES
(8, 1, 1),
(4, 2, 1),
(9, 1, 1),
(7, 1, 3),
(3, 1, 4),
(5, 2, 5),
(8, 3, 3),
(1, 3, 5),
(3, 2, 4);

-- 1. Hien thi danh sach tat ca cac hoc vien
SELECT * FROM Students;

-- 2. Hien thi danh sach tat ca cac mon hoc
SELECT * FROM Subjects;

-- 3. Tinh diem trung binh
-- Theo từng học viên
SELECT s.StudentName, AVG(Mark) AS AVG_Mark FROM Students s 
JOIN Marks m ON m.StudentID = s.StudentID
GROUP BY s.StudentName;

-- Điểm trung bình tất cả học viên
SELECT AVG(AVG_Mark) FROM (
	SELECT s.StudentName, AVG(Mark) AS AVG_Mark FROM Students s 
	JOIN Marks m ON m.StudentID = s.StudentID
	GROUP BY s.StudentName
) AS AVG_Student;

-- 4. Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
SELECT sub.SubjectName, m.Mark FROM Subjects sub 
JOIN Marks m ON sub.SubjectID = m.SubjectID
WHERE Mark = (
	SELECT MAX(Mark) FROM Marks
);

-- 5. Danh so thu tu cua diem theo chieu giam
SELECT RANK() OVER(ORDER BY m.Mark DESC) AS `Rank`, m.Mark FROM Marks m ORDER BY m.Mark DESC;

-- 6. Thay doi kieu du lieu cua cot SubjectName trong bang Subjects thanh nvarchar(max)
ALTER TABLE Subjects
MODIFY SubjectName VARCHAR(255);

-- 7. Cap nhat them dong chu « Day la mon hoc « vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
UPDATE Subjects
SET SubjectName = CONCAT("Day la mon hoc ", SubjectName);

-- 8. Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
ALTER TABLE Students 
MODIFY Age INT CHECK(Age > 15 AND Age < 50);

-- 9. Loai bo tat ca quan he giua cac bang
ALTER TABLE ClassStudent
DROP FOREIGN KEY classstudent_ibfk_1,
DROP FOREIGN KEY classstudent_ibfk_2;

ALTER TABLE Marks
DROP FOREIGN KEY marks_ibfk_1,
DROP FOREIGN KEY marks_ibfk_2;

-- 10. Xoa hoc vien co StudentID la 1
DELETE FROM Students WHERE StudentID = 1;
-- Nếu gặp lỗi Error Code 1451, chạy dòng này, trước khi xoá:  
-- SET foreign_key_checks = 0;

-- 11. Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
ALTER TABLE Students 
ADD COLUMN `Status` BIT DEFAULT(1);

-- 12. Cap nhap gia tri Status trong bang Student thanh 0
UPDATE Students
SET `Status` = 0;
