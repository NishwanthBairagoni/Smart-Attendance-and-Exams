@echo off
TITLE Setting up Database...
CLS

ECHO ===================================================
ECHO      INITIALIZING DATABASE (User: root)
ECHO ===================================================
ECHO.

:: Set credentials (make sure these match your server.js!)
SET DB_USER=root
SET DB_PASS=admin

:: 1. Create Schema and Tables
ECHO [1/5] Creating Database & Tables (schema.sql)...
mysql -u %DB_USER% -p%DB_PASS% < schema.sql
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

:: 2. Create Triggers
ECHO [2/5] Creating Triggers (triggers.sql)...
mysql -u %DB_USER% -p%DB_PASS% college_management < triggers.sql
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

:: 3. Create Procedures
ECHO [3/5] Creating Procedures (procedures.sql)...
mysql -u %DB_USER% -p%DB_PASS% college_management < procedures.sql
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

:: 4. Create Views (FIXES THE REPORT CARD ERROR)
ECHO [4/5] Creating Views (views.sql)...
mysql -u %DB_USER% -p%DB_PASS% college_management < views.sql
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

:: 5. Insert Sample Data
ECHO [5/5] Inserting Sample Data (sample_data.sql)...
mysql -u %DB_USER% -p%DB_PASS% college_management < sample_data.sql
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

ECHO.
ECHO ===================================================
ECHO      SUCCESS! Database is ready.
ECHO ===================================================
ECHO.
ECHO You can now restart your server:
ECHO    node server.js
ECHO.
PAUSE
EXIT /B

:ERROR
ECHO.
ECHO [ERROR] Could not run SQL command. 
ECHO Please check if your password is correct in this script.
ECHO Current Password used: %DB_PASS%
PAUSE
