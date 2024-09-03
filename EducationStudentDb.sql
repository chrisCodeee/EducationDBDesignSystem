CREATE DATABASE EducationStudentDb
USE EducationStudentDb

-- Create the StateMaster table
CREATE TABLE StateMaster (
    StateID INT PRIMARY KEY,
    StateName VARCHAR(50)
);

-- Create the TeacherMaster table
CREATE TABLE TeacherMaster (
    TeacherID CHAR(3) PRIMARY KEY,
    TeacherName VARCHAR(50),
    Subject VARCHAR(50)
);

-- Create the ClassMaster table
CREATE TABLE ClassMaster (
    ClassID INT PRIMARY KEY,
    ClassName VARCHAR(50),
    TeacherID CHAR(3)
);

-- Create the Student table
CREATE TABLE Student (
    StudentID CHAR(3) PRIMARY KEY,
    StudentName VARCHAR(50),
    Age INT,
    ClassID INT,
    StateID INT
);

-- Insert data into the StateMaster table
INSERT INTO StateMaster (StateID, StateName)
VALUES
(101, 'Lagos'),
(102, 'Abuja'),
(103, 'Kano'),
(104, 'Delta'),
(105, 'Ido'),
(106, 'Ibadan'),
(107, 'Enugu'),
(108, 'Kaduna'),
(109, 'Ogun'),
(110, 'Anambra');

-- Insert data into the TeacherMaster table
INSERT INTO TeacherMaster (TeacherID, TeacherName, Subject)
VALUES
('T01', 'Mr. Johnson', 'Mathematics'),
('T02', 'Ms. Smith', 'Science'),
('T03', 'Mr. Williams', 'English'),
('T04', 'Ms. Brown', 'History');

-- Insert data into the ClassMaster table
INSERT INTO ClassMaster (ClassID, ClassName, TeacherID)
VALUES
(1, '10th Grade', 'T01'),
(2, '9th Grade', 'T02'),
(3, '11th Grade', 'T03'),
(4, '12th Grade', 'T04');

-- Insert data into the Student table
INSERT INTO Student (StudentID, StudentName, Age, ClassID, StateID)
VALUES
('S01', 'Alice Brown', 16, 1, 101),
('S02', 'Bob White', 15, 2, 102),
('S03', 'Charlie Black', 17, 3, 103),
('S04', 'Daisy Green', 16, 4, 104),
('S05', 'Edward Blue', 14, 1, 105),
('S06', 'Fiona Red', 15, 2, 106),
('S07', 'George Yellow', 18, 3, 107),
('S08', 'Hannah Purple', 16, 4, 108),
('S09', 'Ian Orange', 17, 1, 109),
('S10', 'Jane Grey', 14, 2, 110);

------------------- (1) Fetch students with the same age. -------------------------------
SELECT Age, COUNT(*) AS StudentCount
FROM Student
GROUP BY Age
HAVING COUNT(*) > 1;

------------------(2) Find the second youngest student and their class and teacher. -------------
SELECT TOP 1 S.StudentName, S.Age, C.ClassName, T.TeacherName
FROM Student S
JOIN ClassMaster C ON S.ClassID = C.ClassID
JOIN TeacherMaster T ON C.TeacherID = T.TeacherID
WHERE S.Age > (SELECT MIN(Age) FROM Student)
ORDER BY S.Age ASC;

-----------------(3) Get the maximum age per class and the student name. ----------------------
SELECT C.ClassName, S.StudentName, S.Age
FROM Student S
JOIN ClassMaster C ON S.ClassID = C.ClassID
WHERE S.Age = (SELECT MAX(Age) FROM Student S2 WHERE S2.ClassID = S.ClassID);

----------------- (4) Teacher-wise count of students sorted by count in descending order. ------------------
SELECT T.TeacherName, COUNT(*) AS StudentCount
FROM Student S
JOIN ClassMaster C ON S.ClassID = C.ClassID
JOIN TeacherMaster T ON C.TeacherID = T.TeacherID
GROUP BY T.TeacherName
ORDER BY StudentCount DESC;

-------------------- (5) Fetch only the first name from the StudentName and append the age.------------------------
SELECT LEFT(StudentName, CHARINDEX(' ', StudentName + ' ') - 1) + ' ' + CAST(Age AS VARCHAR) AS FirstNameWithAge
FROM Student;

---------------- (6) Fetch students with odd ages.--------------------------
SELECT StudentName, Age
FROM Student
WHERE Age % 2 != 0;

-------------------- (7) Create a view to fetch student details with an age greater than 15.-----------------
CREATE VIEW View_Students_Age_Greater_Than_15 AS
SELECT S.StudentID, S.StudentName, S.Age, C.ClassName, T.TeacherName, SM.StateName
FROM Student S
JOIN ClassMaster C ON S.ClassID = C.ClassID
JOIN TeacherMaster T ON C.TeacherID = T.TeacherID
JOIN StateMaster SM ON S.StateID = SM.StateID
WHERE S.Age > 15;

SELECT * FROM View_Students_Age_Greater_Than_15

----------- (8) Create a procedure to update the student's age by 1 year where the class is '10th Grade' and the teacher is not 'Mr. Johnson'.------
CREATE PROCEDURE UpdateStudentAge
AS
BEGIN
    UPDATE S
    SET S.Age = S.Age + 1
    FROM Student S
    JOIN ClassMaster C ON S.ClassID = C.ClassID
    JOIN TeacherMaster T ON C.TeacherID = T.TeacherID
    WHERE C.ClassName = '10th Grade' AND T.TeacherName != 'Mr. Johnson';
END;

EXEC UpdateStudentAge

---------------------- (9) Create a stored procedure to fetch student details along with their class, teacher, and state, including error handling.---
CREATE PROCEDURE FetchStudentDetails
AS
BEGIN
    BEGIN TRY
        SELECT S.StudentID, S.StudentName, S.Age, C.ClassName, T.TeacherName, SM.StateName
        FROM Student S
        JOIN ClassMaster C ON S.ClassID = C.ClassID
        JOIN TeacherMaster T ON C.TeacherID = T.TeacherID
        JOIN StateMaster SM ON S.StateID = SM.StateID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;

EXEC FetchStudentDetails






