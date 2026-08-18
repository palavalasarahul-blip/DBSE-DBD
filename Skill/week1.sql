CREATE DATABASE IF NOT EXISTS 2520090016_Rahul; 
USE 2520090016_Rahul;
CREATE TABLE student_marks1 (
    roll_no INT PRIMARY KEY,
    name VARCHAR(50),
    subject VARCHAR(50),
    marks DECIMAL(5,2)
);

INSERT INTO student_marks1 (roll_no, name, subject, marks) VALUES
(1, 'Ravi', 'Math', 85.50),
(2, 'Sita', 'Math', 92.75),
(3, 'Anil', 'Math', 78.40),
(4, 'Priya', 'Math', 88.90),
(5, 'Vijay', 'Math', 80.25),
(6, 'subbusir', 'aws', 98.50),
(7, 'dwaraka', 'dbms', 95.75),
(8, 'ranjani', 'english', 97.40),
(9, 'kavithamam', 'aws1', 99.90),
(10, 'seetha', 'azure', 82.25);

SELECT * FROM student_marks1;

SELECT COUNT(*) AS total_students FROM student_marks1;
SELECT SUM(marks) FROM student_marks1;
SELECT AVG(marks) FROM student_marks1;
SELECT MAX(marks) FROM student_marks1;
SELECT MIN(marks) FROM student_marks1;

SELECT * FROM student_marks1 WHERE marks > 85;
SELECT * FROM student_marks1 WHERE marks >= 90;
SELECT * FROM student_marks1 WHERE marks < 80;
SELECT * FROM student_marks1 WHERE marks BETWEEN 80 AND 90;
SELECT * FROM student_marks1 WHERE name LIKE 'P%';
SELECT * FROM student_marks1 WHERE name IN ('Ravi', 'Sita', 'Vijay');
SET SQL_SAFE_UPDATES = 0;
UPDATE student_marks1 SET marks = 90.00 WHERE roll_no = 3;
UPDATE student_marks1 SET subject = 'Remedial Math' WHERE marks < 80;

DELETE FROM student_marks1 WHERE roll_no=5;
DELETE FROM student_marks1 WHERE marks<75;

SELECT * FROM student_marks1 ORDER BY marks ASC;
SELECT * FROM student_marks1 ORDER BY marks DESC;
SELECT * FROM student_marks1 ORDER BY name ASC;
SELECT * FROM student_marks1 ORDER BY name DESC;


SELECT subject, SUM(marks) AS total_marks FROM student_marks1 GROUP BY subject;
SELECT subject, AVG(marks) AS avg_marks FROM student_marks1 GROUP BY subject;
SELECT subject, COUNT(*) AS num_students FROM student_marks1 GROUP BY subject;

SELECT subject, AVG(marks) AS avg_marks
FROM student_marks1
GROUP BY subject
HAVING AVG(marks) > 90;

SELECT subject, COUNT(*) AS num_students
FROM student_marks1
GROUP BY subject
HAVING COUNT(*) > 1;
