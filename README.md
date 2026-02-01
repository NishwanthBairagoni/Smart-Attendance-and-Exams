# Student Attendance & Exam Results Management System

## Project Overview
This project is a backend-only MySQL implementation designed to demonstrate **Advanced Database Management Skills**. It simulates a real-world college system handling students, subjects, attendance tracking, and exam result processing with strict data integrity and performance optimizations.

## 📂 Deliverables
- `schema.sql`: 3NF Normalized Database Schema.
- `triggers.sql`: Automates data validation (Duplicate checks, Mark ranges).
- `procedures.sql`: Helper functions for safe data insertion.
- `views.sql`: Simplifies complex reporting logic.
- `sample_data.sql`: Mock data to visualize the system.
- `queries.sql`: Advanced queries for analysis (Attendance < 75%, Top Scorers via Window Functions).

## 🏗 Database Design (3NF)

### Tables
1. **students**: Core student profiles logic.
2. **subjects**: Course details.
3. **attendance**: Daily tracking.
   - *Constraint*: Composite Unique Key (student_id, subject_id, date) prevents duplicates.
4. **exams**: Defines exam details (Midterm, Final).
5. **exam_results**: Stores student marks.

### 🛡 Advanced Features
- **Triggers**:
    - `before_attendance_insert`: Blocks attendance for 'Inactive' students.
    - `before_exam_result_insert`: Ensures marks do not exceed `max_marks` of the defined exam.
- **Stored Procedures**:
    - `sp_mark_attendance`: Transaction-safe wrapper.
    - `sp_add_exam_result`: Transaction-safe wrapper.
- **Views**:
    - `v_attendance_summary`: Aggregates daily logs into percentage stats.
    - `v_student_report_card`: Calculates Pass/Fail status dynamically.

## 🚀 How to Run
Run the SQL files in this specific order to avoid dependency errors:
```sql
source schema.sql;
source triggers.sql;
source procedures.sql;
source views.sql;
source sample_data.sql;
-- Now run queries
source queries.sql;
```



## 🌐 Web Dashboard (Optional)
This project includes a Node.js/Express dashboard to visualize the data.

### 1-Click Start (Windows)
Double-click `START_HERE.bat` in the project folder.

### Manual Start
1. **Configure Password**: Update the `db.password` in `server.js` (or run `node setup_password.js`).
2. **Install Dependencies**:
   ```bash
   npm install
   ```
3. **Start Server**:
   ```bash
   node server.js
   ```
4. **View**: Open `http://localhost:3000`

## 🎤 Interview Readiness Q&A

**Q: Why did you use `ENUM` for status?**
A: `ENUM` enforces data integrity at the schema level, creating a fixed list of allowed values (e.g., 'Present', 'Absent') which is more storage-efficient than VARCHAR and prevents typo-based errors.

**Q: How do you handle duplicate attendance?**
A: I implemented a **Composite Unique Constraint** on `(student_id, subject_id, date)`. Additionally, a `BEFORE INSERT` trigger provides a user-friendly error message if a duplicate is attempted.

**Q: Why use Views?**
A: Views abstract complex joins (like the report card logic) into a virtual table. This enhances security (hiding raw tables) and simplifies application-side queries.

**Q: How do you find the top 3 scorers per subject?**
A: I used the `DENSE_RANK()` window function partitioned by `subject_id` and ordered by `marks_obtained DESC`, which handles ties gracefully (unlike `LIMIT`).
