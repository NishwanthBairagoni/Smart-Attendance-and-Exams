USE college_management;

CREATE TABLE IF NOT EXISTS exam_results (
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

CREATE INDEX idx_results_student ON exam_results(student_id);
