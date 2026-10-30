@echo off
rem Double-click to install the skills on Windows. Opens a menu.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\install.ps1" %*
echo.
pause
