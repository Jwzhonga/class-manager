@echo off
chcp 65001 >nul 2>&1
title ClassManager
cd /d "%~dp0"
setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Class Management System
echo ========================================

:: ---------- Check / Install Python ----------
set PYTHON=
py --version >nul 2>&1
if %errorlevel% equ 0 ( set PYTHON=py ) else (
    python --version >nul 2>&1
    if %errorlevel% equ 0 ( set PYTHON=python )
)

if "%PYTHON%"=="" (
    echo.
    echo [INFO] Python not detected.
    echo [1/4] Detecting system...
    ver | find "10.0" >nul && echo   Windows 10/11 detected || (
        ver | find "6.1" >nul && echo   Windows 7 detected || echo   Windows detected
    )
    echo [2/4] Trying to download Python 3.12...
    echo.
    echo (Copy this link to your browser if download fails:)
    echo https://mirrors.tuna.tsinghua.edu.cn/python/3.12.10/python-3.12.10-amd64.exe
    echo.

    set "MIRROR=https://mirrors.tuna.tsinghua.edu.cn/python/3.12.10/python-3.12.10-amd64.exe"
    set "OUT=%TEMP%\python-installer.exe"
    set DOWNLOADED=0

    echo Trying: bitsadmin + TUNA mirror...
    bitsadmin /transfer "PythonDownload" /download /priority high "%MIRROR%" "%OUT%" 2>&1
    if exist "%OUT%" (set DOWNLOADED=1) else (echo FAILED)

    if !DOWNLOADED! equ 0 (
        echo Trying: certutil + TUNA mirror...
        certutil -urlcache -split -f "%MIRROR%" "%OUT%" 2>&1
        if exist "%OUT%" (set DOWNLOADED=1) else (echo FAILED)
    )

    if !DOWNLOADED! equ 0 (
        echo Trying: PowerShell + TUNA mirror...
        powershell -Command "$wc=New-Object net.webclient; try{echo downloading...;$wc.DownloadFile('%MIRROR%','%OUT%');echo ok}catch{echo error: $_.Exception.Message;exit 1}"
        if exist "%OUT%" (set DOWNLOADED=1) else (echo FAILED)
    )

    if !DOWNLOADED! equ 0 (
        echo.
        echo All download methods failed.
        echo The school network may be blocking file downloads.
        echo.
        echo Solution: Download Python manually:
        echo 1. Open this link in your browser:
        echo    https://mirrors.tuna.tsinghua.edu.cn/python/3.12.10/python-3.12.10-amd64.exe
        echo 2. Save the installer
        echo 3. Run this script again
        echo.
        pause
        exit /b 1
    )
    echo [2/4] Installing Python...
    start /wait "" "%TEMP%\python-installer.exe" /quiet InstallAllUsers=0 PrependPath=1 Include_pip=1
    set "PATH=%LOCALAPPDATA%\Programs\Python\Python312\;%LOCALAPPDATA%\Programs\Python\Python312\Scripts\;%PATH%"
    set PYTHON=python
    echo [OK] Python installed.
)

:: ---------- Create venv ----------
if not exist "venv\Scripts\python.exe" (
    echo.
    echo [3/4] Creating virtual environment...
    %PYTHON% -m venv venv
    if %errorlevel% neq 0 (
        echo [INFO] Trying pip virtualenv...
        pip install virtualenv >nul 2>&1
        virtualenv venv
    )
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to create venv.
        pause
        exit /b 1
    )
)

:: ---------- Install dependencies ----------
venv\Scripts\python -c "import flask" >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [3/4] Installing dependencies...
    venv\Scripts\pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ flask flask-sqlalchemy openpyxl xlrd reportlab matplotlib pillow
)

:: Verify installation
venv\Scripts\python -c "import flask; import flask_sqlalchemy; import openpyxl; import xlrd; import reportlab; import matplotlib; import PIL" >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies.
    pause
    exit /b 1
)

:: ---------- Ensure directories ----------
if not exist "instance" mkdir instance
if not exist "static\uploads" mkdir static\uploads

:: ---------- Launch ----------
echo.
echo [4/4] Starting server in background...
echo.
echo ========================================
echo   Server is running in background
echo   Open browser to: http://localhost:5800
echo   Login: admin / admin123
echo   Close this window safely - server keeps running
echo   To stop: double-click stop_server.bat
echo ========================================

:: Run in background with pythonw (no console window)
start /b "" "venv\Scripts\pythonw.exe" app.py --port 5800
echo [OK] Server started on port 5800
echo.
echo This window can be closed now.
echo The server will continue running in the background.
echo To stop the server, run stop_server.bat
echo.
pause
