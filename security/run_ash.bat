@echo off

echo Running AWS ASH Scan...

ash --mode local

IF %ERRORLEVEL% NEQ 0 (
    echo ASH Scan Failed
    exit /b 1
)

echo ASH Scan Passed
exit /b 0