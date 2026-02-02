const mysql = require('mysql2');

const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'admin',
    database: 'college_management'
});

connection.connect((err) => {
    if (err) {
        console.error('Error connecting: ' + err.stack);
        return;
    }

    connection.query("SHOW TABLES LIKE 'exam_results'", (error, results) => {
        if (error) throw error;
        if (results.length > 0) {
            console.log("Table exam_results exists!");
        } else {
            console.log("Table exam_results does NOT exist.");
        }
        connection.end();
    });
});
