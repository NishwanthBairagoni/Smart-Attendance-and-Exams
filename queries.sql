USE college_management;

-- =======================================================
-- Query 1: Students with Attendance Below 75%
-- Uses the VIEW created earlier for simplicity
-- =======================================================
SELECT student_name, subject_name, attendance_percentage
FROM v_attendance_summary
WHERE attendance_percentage < 75.00;

-- =======================================================
-- Query 2: Top 3 Scorers Per Subject (Ranked)
-- Demonstrates Window Functions (RANK/DENSE_RANK)
-- =======================================================
SELECT * FROM (
    SELECT 
        sub.subject_name,
        s.first_name,
        s.last_name,
        er.marks_obtained,
        DENSE_RANK() OVER (PARTITION BY e.subject_id ORDER BY er.marks_obtained DESC) as rank_in_subject
    FROM exam_results er
    JOIN exams e ON er.exam_id = e.exam_id
    JOIN subjects sub ON e.subject_id = sub.subject_id
    JOIN students s ON er.student_id = s.student_id
) ranked_results
WHERE rank_in_subject <= 3;

-- =======================================================
-- Query 3: Students Who Failed at Least One Subject
-- Finds unique students who have a 'Fail' status in report card view
-- =======================================================
SELECT DISTINCT student_name
FROM v_student_report_card
WHERE result_status = 'Fail';

-- =======================================================
-- Query 4: Average Marks Per Subject
-- Basic aggregation
-- =======================================================
SELECT 
    sub.subject_name,
    AVG(er.marks_obtained) as average_marks,
    MIN(er.marks_obtained) as min_marks,
    MAX(er.marks_obtained) as max_marks
FROM exam_results er
JOIN exams e ON er.exam_id = e.exam_id
JOIN subjects sub ON e.subject_id = sub.subject_id
GROUP BY sub.subject_name;

-- =======================================================
-- Query 5: Identify Potential Dropouts (Low Attendance AND Low Marks)
-- Complex Logic combining multiple metrics
-- =======================================================
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS full_name
FROM students s
JOIN v_attendance_summary att ON s.student_id = att.student_id
JOIN v_student_report_card rep ON s.student_id = rep.student_id
WHERE att.attendance_percentage < 60 
AND rep.result_status = 'Fail'
GROUP BY s.student_id;
