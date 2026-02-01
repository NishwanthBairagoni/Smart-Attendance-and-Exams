@echo off
TITLE Smart Campus - One-Click Setup
CLS

ECHO ==========================================================
ECHO      SMART CAMPUS - AUTOMATED SETUP & LAUNCHER
ECHO ==========================================================
ECHO.

:: 1. Check if Node is installed
node -v >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO [ERROR] Node.js is NOT installed.
    ECHO Please install Node.js from https://nodejs.org/
    PAUSE
    EXIT /B
)

:: 2. Run Password Setup (Interactive)
ECHO [STEP 1/3] Configure Database Security...
call node setup_password.js

:: 3. Install Dependencies
ECHO.
ECHO [STEP 2/3] Installing System Dependencies (this may take a minute)...
call npm install
IF %ERRORLEVEL% NEQ 0 (
    ECHO [ERROR] Failed to install dependencies.
    PAUSE
    EXIT /B
)

:: 4. Start Server
ECHO.
ECHO [STEP 3/3] Starting Dashboard...
ECHO.
ECHO    -----------------------------------------
ECHO    SUCCESS! Open your browser to:
ECHO    http://localhost:3000
ECHO    -----------------------------------------
ECHO.
node server.js
PAUSE
