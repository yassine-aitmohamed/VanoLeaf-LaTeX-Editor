@echo off
chcp 65001 >nul
set "PYTHONUTF8=1"
cd /d "%~dp0"
if not exist "venv\Scripts\python.exe" (
  echo VanoLeaf is not installed yet. Double-click INSTALL.bat first.
  pause
  exit /b 1
)
title VanoLeaf  (close this window to stop it)
"venv\Scripts\python.exe" app.py
pause
