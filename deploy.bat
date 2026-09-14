@echo off
setlocal
title Deploy Public Witness to Vercel
echo Deploying garth-murray-public-witness to Production...
cd /d "%~dp0"
call npx -y vercel --prod --yes
pause
