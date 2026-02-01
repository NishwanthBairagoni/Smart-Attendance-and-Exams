@echo off
TITLE Stop Server
echo Finding process on port 3000...

for /f "tokens=5" %%a in ('netstat -aon ^| find ":3000" ^| find "LISTENING"') do (
    echo Killing process %%a...
    taskkill /f /pid %%a
)

echo.
echo Done. You can now run START_HERE.bat again!
pause
