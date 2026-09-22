@echo off
setlocal
title Deploy Public Witness to Vercel
echo [1/2] Verifying Vercel CLI session...
call npx -y vercel whoami >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Vercel CLI is not logged in. Starting login...
    call npx -y vercel login murraygarth80@gmail.com
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Authentication was not completed.
        pause
        exit /b 1
    )
)
echo [2/2] Deploying garth-murray-public-witness to Production...
cd /d "%~dp0"
call npx -y vercel --prod --yes
pause
