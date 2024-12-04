@echo off
setlocal enabledelayedexpansion

:: Set Ollama base path
set "OLLAMA_ROOT=%~dp0"
set "OLLAMA_ROOT=%OLLAMA_ROOT:~0,-1%"

:: Set necessary environment variables
set "OLLAMA_MODELS=%OLLAMA_ROOT%\.ollama\models"
set "OLLAMA_HOME=%OLLAMA_ROOT%\.ollama"
set "APPDATA=%OLLAMA_ROOT%\AppData"
set "LOCALAPPDATA=%OLLAMA_ROOT%\AppData\Local"
set "PATH=%OLLAMA_ROOT%\Programs\Ollama;%PATH%"

:: Set CUDA environment variables
::set "CUDA_LAUNCH_BLOCKING=1"
::set "CUDA_VISIBLE_DEVICES=0"

:: Check if Ollama is already running
tasklist /FI "IMAGENAME eq ollama.exe" 2>NUL | find /I /N "ollama.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo Ollama is already running!
    echo Close the existing instance before starting a new one.
    pause
    exit /b 1
)

echo Starting Ollama in portable mode...
echo Base directory: %OLLAMA_ROOT%
echo.

:: Start Ollama in background
start "" "%OLLAMA_ROOT%\Programs\Ollama\ollama.exe" serve

:: Wait a few seconds for server startup
timeout /t 5 /nobreak > nul

:: Start frontend if present
if exist "%OLLAMA_ROOT%\Programs\Ollama\ollama app.exe" (
    start "" "%OLLAMA_ROOT%\Programs\Ollama\ollama app.exe"
)

:: Show help command to verify functionality
echo.
echo Verifying Ollama functionality with help command:
echo ==============================================
echo.
"%OLLAMA_ROOT%\Programs\Ollama\ollama.exe" help

echo.
echo Ollama is active and listening. Do not close this window to keep Ollama running.
echo To terminate Ollama, close this window.
cmd /k