const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const path = require('path');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Database Connection
// NOTE: Please update the password below to match your local MySQL password
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'admin',
    database: 'college_management'
});

db.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL:', err.message);
        console.log('---------------------------------------------------');
        console.log('PLEASE OPEN server.js AND UPDATE THE "password" FIELD');
        console.log('---------------------------------------------------');
        return;
    }
    console.log('Connected to MySQL database: college_management');
});

// API Routes

// 1. Get All Students
app.get('/api/students', (req, res) => {
    const query = 'SELECT * FROM students ORDER BY student_id DESC';
    db.query(query, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 2. Get Report Card (Using the View)
app.get('/api/report-cards', (req, res) => {
    const query = 'SELECT * FROM v_student_report_card';
    db.query(query, (err, results) => {
        if (err) return res.status(500).json({ error: "View 'v_student_report_card' might not exist. " + err.message });
        res.json(results);
    });
});

// 3. Get Attendance Summary (Using the View)
app.get('/api/attendance-summary', (req, res) => {
    const query = 'SELECT * FROM v_attendance_summary';
    db.query(query, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
