@echo off
setlocal EnableDelayedExpansion

echo =====================================================
echo AWS ASH SECURITY AGENT BOOTSTRAP
echo =====================================================

echo.
echo [STEP 1] Verifying Git...
where git >nul 2>&1

IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Git is not installed.
    exit /b 1
)

echo [OK] Git Found

echo.
echo [STEP 2] Verifying Python...
where python >nul 2>&1

IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Python is not installed.
    exit /b 1
)

echo [OK] Python Found
python --version

echo.
echo [STEP 3] Verifying pip...
where pip >nul 2>&1

IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] pip is not installed.
    exit /b 1
)

echo [OK] pip Found

echo.
echo [STEP 4] Verifying NodeJS...
where node >nul 2>&1

IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] NodeJS is not installed.
    echo Please install NodeJS 18+.
    exit /b 1
)

echo [OK] NodeJS Found
node --version

echo.
echo [STEP 5] Verifying npm...
where npm >nul 2>&1

IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] npm is not installed.
    exit /b 1
)

echo [OK] npm Found
npm --version

echo.
echo DEBUG: Reached Step 6
pause

echo.
echo [STEP 6] Verifying Ruby...
where ruby >nul 2>&1

IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Ruby is not installed.
    echo cfn_nag requires Ruby.
    exit /b 1
)

echo [OK] Ruby Found
ruby --version

echo.
echo [STEP 7] Installing AWS ASH...

pip install --upgrade git+https://github.com/awslabs/automated-security-helper.git@v3.5.3

IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install AWS ASH.
    exit /b 1
)

echo [OK] AWS ASH Installed

echo.
echo [STEP 8] Verifying ASH...

ash --version

IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] ASH verification failed.
    exit /b 1
)

echo [OK] AWS ASH Verified

echo.
echo [STEP 9] Installing pre-commit...

pip install --upgrade pre-commit

IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install pre-commit.
    exit /b 1
)

echo [OK] pre-commit Installed

echo.
echo [STEP 10] Validating Repository Configuration...

IF NOT EXIST ".pre-commit-config.yaml" (
    echo [ERROR] .pre-commit-config.yaml not found.
    exit /b 1
)

IF NOT EXIST "security\run_ash.bat" (
    echo [ERROR] security\run_ash.bat not found.
    exit /b 1
)

echo [OK] Repository Configuration Found

echo.
echo [STEP 11] Installing Git Pre-Commit Hook...

pre-commit install

IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install pre-commit hook.
    exit /b 1
)

echo [OK] Pre-Commit Hook Installed

echo.
echo [STEP 12] Installing Git Pre-Push Hook...

pre-commit install --hook-type pre-push

IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install pre-push hook.
    exit /b 1
)

echo [OK] Pre-Push Hook Installed

echo.
echo [STEP 13] Verifying Installed Hooks...

IF NOT EXIST ".git\hooks\pre-commit" (
    echo [ERROR] pre-commit hook not found.
    exit /b 1
)

IF NOT EXIST ".git\hooks\pre-push" (
    echo [ERROR] pre-push hook not found.
    exit /b 1
)

echo [OK] Git Hooks Verified

echo.
echo [STEP 14] Running ASH Validation Scan...

ash --mode local

IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo [WARNING] ASH executed successfully but security findings were detected.
    echo Bootstrap completed.
    echo Fix findings before committing code.
) ELSE (
    echo [OK] ASH Validation Passed
)

echo.
echo =====================================================
echo BOOTSTRAP COMPLETED SUCCESSFULLY
echo =====================================================
echo.
echo Installed Components:
echo.
echo    [OK] Git
echo    [OK] Python
echo    [OK] pip
echo    [OK] NodeJS
echo    [OK] npm
echo    [OK] Ruby
echo    [OK] AWS ASH
echo    [OK] pre-commit
echo    [OK] Pre-Commit Hook
echo    [OK] Pre-Push Hook
echo.
echo Security Agent Ready
echo.

exit /b 0