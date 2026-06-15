@echo off

ash --mode local

IF %ERRORLEVEL% NEQ 0 (

    echo Security scan failed.

    start .ash\ash_output\reports\ash.html

    exit /b 1
)

exit /b 0