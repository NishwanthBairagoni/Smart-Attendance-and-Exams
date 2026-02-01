USE college_management;

DELIMITER //

-- ==========================================
-- Procedure: Mark Attendance
-- Wrapper for inserting attendance safely
-- ==========================================
CREATE PROCEDURE sp_mark_attendance(
    IN p_student_id INT,
    IN p_subject_id INT,
    IN p_date DATE,
    IN p_status ENUM('Present', 'Absent', 'Late', 'Excused')
)
BEGIN
    -- Using Transaction to ensure atomicity
    START TRANSACTION;
    
    INSERT INTO attendance (student_id, subject_id, date, status)
    VALUES (p_student_id, p_subject_id, p_date, p_status);
    
    COMMIT;
END //

-- ==========================================
-- Procedure: Add Exam Result
-- Wrapper for inserting exam results
-- ==========================================
CREATE PROCEDURE sp_add_exam_result(
    IN p_exam_id INT,
    IN p_student_id INT,
    IN p_marks DECIMAL(5,2)
)
BEGIN
    START TRANSACTION;
    
    INSERT INTO exam_results (exam_id, student_id, marks_obtained)
    VALUES (p_exam_id, p_student_id, p_marks);
    
    COMMIT;
END //

-- ==========================================
-- Procedure: Enroll Student (Helper)
-- ==========================================
CREATE PROCEDURE sp_enroll_student(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_enrollment_date DATE
)
BEGIN
    INSERT INTO students (first_name, last_name, email, enrollment_date)
    VALUES (p_first_name, p_last_name, p_email, p_enrollment_date);
END //

DELIMITER ;
