USE college_management;

-- Disable FK checks to allow bulk loading order independence (optional, but convenient)
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Insert Subjects
INSERT INTO subjects (subject_name, subject_code, description, credits) VALUES 
('Database Management Systems', 'CS101', 'Intro to SQL and DB Design', 4),
('Operating Systems', 'CS102', 'Process management and memory', 4),
('Mathematics', 'MT201', 'Calculus and Linear Algebra', 3);

-- 2. Insert Students
INSERT INTO students (first_name, last_name, email, enrollment_date, status) VALUES 
('John', 'Doe', 'john.doe@example.com', '2023-08-01', 'Active'),
('Jane', 'Smith', 'jane.smith@example.com', '2023-08-01', 'Active'),
('Alice', 'Johnson', 'alice.j@example.com', '2023-09-01', 'Active'),
('Bob', 'Brown', 'bob.b@example.com', '2023-08-15', 'Active'),
('Charlie', 'Davis', 'charlie.d@example.com', '2023-08-01', 'Inactive');

-- 3. Insert Exams
INSERT INTO exams (subject_id, exam_type, exam_date, max_marks) VALUES 
(1, 'Midterm', '2023-10-10', 100), -- CS101
(1, 'Final', '2023-12-15', 100),   -- CS101
(2, 'Midterm', '2023-10-12', 50),  -- CS102
(3, 'Internal', '2023-09-20', 20); -- MT201

-- 4. Insert Attendance (Calling procedure normally, but for bulk script we use direct insert or call)
-- Here we use direct inserts for speed and simplicity in sample data
INSERT INTO attendance (student_id, subject_id, date, status) VALUES 
(1, 1, '2023-09-01', 'Present'), (1, 1, '2023-09-02', 'Present'), (1, 1, '2023-09-03', 'Absent'),
(2, 1, '2023-09-01', 'Present'), (2, 1, '2023-09-02', 'Late'),    (2, 1, '2023-09-03', 'Present'),
(3, 1, '2023-09-01', 'Absent'),  (3, 1, '2023-09-02', 'Absent'),  (3, 1, '2023-09-03', 'Absent'), -- Low attendance example
(1, 2, '2023-09-01', 'Present'), (1, 2, '2023-09-05', 'Present'),
(2, 2, '2023-09-01', 'Present'), (2, 2, '2023-09-05', 'Excused');

-- 5. Insert Exam Results
-- Exam 1 (CS101 Midterm)
INSERT INTO exam_results (exam_id, student_id, marks_obtained) VALUES 
(1, 1, 85.5), -- John passed
(1, 2, 92.0), -- Jane passed
(1, 3, 35.0), -- Alice failed (<40)
(1, 4, 78.0); -- Bob passed

-- Exam 3 (CS102 Midterm - Max 50)
INSERT INTO exam_results (exam_id, student_id, marks_obtained) VALUES 
(3, 1, 45.0), -- 45/50
(3, 2, 48.0), -- 48/50
(3, 3, 15.0); -- 15/50 (Fail)

SET FOREIGN_KEY_CHECKS = 1;
