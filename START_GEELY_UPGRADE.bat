@echo off
title HE THONG TU DONG HOA GEELY COOLRAY 2026
color 0B
echo ================================================================
echo    DANG KHOI DONG BANG DIEU KHIEN NANG CAP GEELY COOLRAY 2026...
echo ================================================================
cd /d "%~dp0scripts"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "run_all.ps1"
pause
