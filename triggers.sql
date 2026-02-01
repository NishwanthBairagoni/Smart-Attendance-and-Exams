USE college_management;

DELIMITER //

-- ==========================================
-- Trigger: Prevent duplicate attendance & Check Student Status
-- 1. Checks if student is 'Active'
-- 2. Checks if attendance already exists (Duplicate check)
-- ==========================================
CREATE TRIGGER before_attendance_insert
BEFORE INSERT ON attendance
FOR EACH ROW
BEGIN
    DECLARE student_status VARCHAR(20);
    
    -- Fetch student status
    SELECT status INTO student_status 
    FROM students 
    WHERE student_id = NEW.student_id;
    
    -- Business Rule: Only Active students can have attendance marked
    IF student_status != 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Cannot mark attendance for inactive or graduated students.';
    END IF;

    -- Business Rule: Prevent duplicates (Alternative to Unique Constraint for custom error)
    -- Note: valid only if we want to catch it before the key constraint, usually the Unique Key catches it efficiently, 
    -- but this allows a friendlier error message.
    IF EXISTS (SELECT 1 FROM attendance WHERE student_id = NEW.student_id AND subject_id = NEW.subject_id AND date = NEW.date) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Attendance already marked for this student, subject, and date.';
    END IF;
END //

-- ==========================================
-- Trigger: Validate Exam Marks
-- Ensures marks_obtained does not exceed the exam's max_marks
-- ==========================================
CREATE TRIGGER before_exam_result_insert
BEFORE INSERT ON exam_results
FOR EACH ROW
BEGIN
    DECLARE exam_max INT;
    
    -- Get max marks for the exam
    SELECT max_marks INTO exam_max 
    FROM exams 
    WHERE exam_id = NEW.exam_id;
    
    -- Validation
    IF NEW.marks_obtained > exam_max THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Marks obtained cannot exceed the maximum marks for this exam.';
    END IF;
END //

DELIMITER ;
