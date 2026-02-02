USE college_management;

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
