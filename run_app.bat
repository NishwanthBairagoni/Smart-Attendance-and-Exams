@echo off
echo Installing dependencies...
call npm install
if %errorlevel% neq 0 (
    echo Error installing dependencies. Please check your Node.js installation.
    pause
    exit /b
)

echo.
echo Starting Smart Campus Server...
echo IMPORTANT: Make sure you have updated the 'password' in server.js!
echo.
node server.js
pause
