const API_URL = 'http://localhost:3000/api';

document.addEventListener('DOMContentLoaded', () => {
    // Navigate to default tab
    loadTab('students');

    // Setup Navigation
    document.querySelectorAll('.nav-item').forEach(button => {
        button.addEventListener('click', () => {
            // Update UI
            document.querySelectorAll('.nav-item').forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');

            // Load Content
            const tab = button.getAttribute('data-tab');
            loadTab(tab);
        });
    });
});

function loadTab(tabName) {
    const contentArea = document.getElementById('content-area');
    const pageTitle = document.getElementById('page-title');

    contentArea.innerHTML = '<div class="loading-spinner">Loading...</div>'; // Simple loading state

    if (tabName === 'students') {
        pageTitle.innerText = 'Student Directory';
        fetchAndRenderStudents();
    } else if (tabName === 'reports') {
        pageTitle.innerText = 'Report Cards';
        fetchAndRenderReports();
    } else if (tabName === 'attendance') {
        pageTitle.innerText = 'Attendance Summary';
        fetchAndRenderAttendance();
    }
}

async function fetchAndRenderStudents() {
    try {
        const response = await fetch(`${API_URL}/students`);
        const data = await response.json();

        if (data.error) throw new Error(data.error);
        if (data.length === 0) {
            renderEmptyState('No students found. Add some via SQL!');
            return;
        }

        let html = `
            <div class="data-table-container fade-in">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Enrolled</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
        `;

        data.forEach(student => {
            html += `
                <tr>
                    <td>#${student.student_id}</td>
                    <td><b>${student.first_name} ${student.last_name}</b></td>
                    <td>${student.email}</td>
                    <td>${new Date(student.enrollment_date).toLocaleDateString()}</td>
                    <td><span class="badge badge-${student.status.toLowerCase()}">${student.status}</span></td>
                </tr>
            `;
        });

        html += '</tbody></table></div>';
        document.getElementById('content-area').innerHTML = html;

    } catch (error) {
        renderError(error);
    }
}

async function fetchAndRenderReports() {
    try {
        const response = await fetch(`${API_URL}/report-cards`);
        const data = await response.json();

        if (data.error) throw new Error(data.error);

        // NOTE: This assumes the View 'v_student_report_card' has columns: student_id, student_name, subject, marks, grade, etc.
        // We will adapt the table to whatever the view returns, but let's try to be specific based on commmon patterns

        if (data.length === 0) {
            renderEmptyState('No exam results found yet.');
            return;
        }

        // Dynamically generate headers based on first object keys
        const headers = Object.keys(data[0]);

        let html = `
            <div class="data-table-container fade-in">
                <table>
                    <thead>
                        <tr>
                            ${headers.map(h => `<th>${h.replace(/_/g, ' ')}</th>`).join('')}
                        </tr>
                    </thead>
                    <tbody>
        `;

        data.forEach(row => {
            html += '<tr>';
            headers.forEach(key => {
                let cellValue = row[key];
                // basic formatting
                if (key.includes('status') || key.includes('grade')) {
                    cellValue = `<span class="badge badge-${String(cellValue).toLowerCase()}">${cellValue}</span>`;
                }
                html += `<td>${cellValue}</td>`;
            });
            html += '</tr>';
        });

        html += '</tbody></table></div>';
        document.getElementById('content-area').innerHTML = html;

    } catch (error) {
        renderError(error);
    }
}

async function fetchAndRenderAttendance() {
    try {
        const response = await fetch(`${API_URL}/attendance-summary`);
        const data = await response.json();

        if (data.error) throw new Error(data.error);
        if (data.length === 0) {
            renderEmptyState('No attendance records found.');
            return;
        }

        // Dynamically generate headers based on first object keys
        const headers = Object.keys(data[0]);

        let html = `
           <div class="data-table-container fade-in">
               <table>
                   <thead>
                       <tr>
                           ${headers.map(h => `<th>${h.replace(/_/g, ' ')}</th>`).join('')}
                       </tr>
                   </thead>
                   <tbody>
       `;

        data.forEach(row => {
            html += '<tr>';
            headers.forEach(key => {
                // percent formatting
                let cellValue = row[key];
                if (key.includes('percent')) {
                    cellValue = `<b>${cellValue}%</b>`;
                }
                html += `<td>${cellValue}</td>`;
            });
            html += '</tr>';
        });

        html += '</tbody></table></div>';
        document.getElementById('content-area').innerHTML = html;

    } catch (error) {
        renderError(error);
    }
}

function renderError(error) {
    document.getElementById('content-area').innerHTML = `
        <div style="color: #ef4444; padding: 2rem; text-align: center;">
            <h3>⚠️ Error connecting to server</h3>
            <p>${error.message}</p>
            <br>
            <p style="color: #94a3b8; font-size: 0.9em;">Make sure <b>server.js</b> is running and the database password is correct.</p>
        </div>
    `;
}

function renderEmptyState(message) {
    document.getElementById('content-area').innerHTML = `
        <div style="text-align: center; padding: 3rem; color: #94a3b8;">
            <p>${message}</p>
        </div>
    `;
}
