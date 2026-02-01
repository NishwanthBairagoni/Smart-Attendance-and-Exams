-- Database Creation
CREATE DATABASE IF NOT EXISTS college_management;
USE college_management;

-- ==========================================
-- 1. Students Table
-- 3NF: All columns depend directly on primary key (student_id).
-- ==========================================
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Primary Key for student identification',
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE COMMENT 'Unique constraint to prevent duplicate emails',
    enrollment_date DATE NOT NULL,
    status ENUM('Active', 'Inactive', 'Graduated', 'Suspended') DEFAULT 'Active' COMMENT 'Enum to restrict status values',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 2. Subjects Table
-- 3NF: Subject details depend on subject_id.
-- ==========================================
CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    subject_code VARCHAR(20) NOT NULL UNIQUE COMMENT 'Unique subject code (e.g., CS101)',
    description TEXT,
    credits INT DEFAULT 3 CHECK (credits > 0) COMMENT 'Check constraint to ensure positive credits'
);

-- ==========================================
-- 3. Exams Table
-- 3NF: Exam details depend on exam_id.
-- ==========================================
CREATE TABLE exams (
    exam_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT NOT NULL,
    exam_type ENUM('Midterm', 'Final', 'Internal', 'Quiz') NOT NULL COMMENT 'Categorize exam types',
    exam_date DATE NOT NULL,
    max_marks INT DEFAULT 100 CHECK (max_marks > 0),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id) ON DELETE CASCADE COMMENT 'FK to link exam to a subject'
);

-- ==========================================
-- 4. Attendance Table
-- Core Focus: Daily attendance tracking.
-- ==========================================
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    date DATE NOT NULL,
    status ENUM('Present', 'Absent', 'Late', 'Excused') NOT NULL,
    remarks VARCHAR(255),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id) ON DELETE CASCADE,
    -- Composite Unique Key: A student can only have one attendance record per subject per day
    UNIQUE KEY unique_attendance (student_id, subject_id, date) COMMENT 'Prevent duplicate attendance entries'
);

-- ==========================================
-- 5. Exam Results Table
-- Core Focus: Storing marks.
-- ==========================================
CREATE TABLE exam_results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT NOT NULL,
    student_id INT NOT NULL,
    marks_obtained DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    -- Constraint: Marks cannot exceed max_marks (enforced via Trigger usually, but basic range check here)
    CHECK (marks_obtained >= 0),
    -- Ensure one result per student per exam
    UNIQUE KEY unique_exam_result (exam_id, student_id)
);

-- ==========================================
-- Indexes for Performance
-- Optimization for frequent search/filter columns
-- ==========================================

-- Speed up attendance calculation by student
CREATE INDEX idx_attendance_student ON attendance(student_id);

-- Speed up fetching attendance by date (e.g., daily reports)
CREATE INDEX idx_attendance_date ON attendance(date);

-- Speed up checking subject-wise performance
CREATE INDEX idx_results_subject ON exams(subject_id);

-- Speed up student result history
CREATE INDEX idx_results_student ON exam_results(student_id);
