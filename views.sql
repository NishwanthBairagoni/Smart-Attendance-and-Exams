USE college_management;

-- ==========================================
-- View: Attendance Summary
-- Calculates total classes, present count, and attendance percentage per student per subject
-- ==========================================
CREATE OR REPLACE VIEW v_attendance_summary AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    sub.subject_name,
    COUNT(a.subject_id) AS total_classes,
    SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS classes_attended,
    ROUND(
        (SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) / COUNT(a.subject_id)) * 100, 
        2
    ) AS attendance_percentage
FROM students s
JOIN attendance a ON s.student_id = a.student_id
JOIN subjects sub ON a.subject_id = sub.subject_id
GROUP BY s.student_id, sub.subject_id;

-- ==========================================
-- View: Student Report Card
-- Shows detailed exam results and Pass/Fail status
-- ==========================================
CREATE OR REPLACE VIEW v_student_report_card AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    sub.subject_name,
    e.exam_type,
    er.marks_obtained,
    e.max_marks,
    ROUND((er.marks_obtained / e.max_marks) * 100, 2) AS percentage,
    CASE 
        WHEN (er.marks_obtained / e.max_marks) * 100 >= 40 THEN 'Pass'
        ELSE 'Fail'
    END AS result_status
FROM students s
JOIN exam_results er ON s.student_id = er.student_id
JOIN exams e ON er.exam_id = e.exam_id
JOIN subjects sub ON e.subject_id = sub.subject_id;
