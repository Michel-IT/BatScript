@echo off
setlocal enabledelayedexpansion

echo Creating Portable Version of Ollama
echo =================================

:: Set source and destination paths
set "SOURCE_ROOT=%LOCALAPPDATA%"
set "DEST_ROOT=C:\OllamaPortable"

:: Check possible installation paths
set "OLLAMA_INSTALL_PATH="
if exist "C:\Program Files\Ollama" (
    set "OLLAMA_INSTALL_PATH=C:\Program Files\Ollama"
) else if exist "C:\Program Files (x86)\Ollama" (
    set "OLLAMA_INSTALL_PATH=C:\Program Files (x86)\Ollama"
) else if exist "%LOCALAPPDATA%\Programs\Ollama" (
    set "OLLAMA_INSTALL_PATH=%LOCALAPPDATA%\Programs\Ollama"
)

if "%OLLAMA_INSTALL_PATH%"=="" (
    echo ERROR: Ollama installation not found!
    echo Please ensure Ollama is installed correctly
    echo Common paths checked:
    echo - C:\Program Files\Ollama
    echo - C:\Program Files ^(x86^)\Ollama
    echo - %LOCALAPPDATA%\Programs\Ollama
    pause
    exit /b 1
)

:: Create main directory if it doesn't exist
if not exist "%DEST_ROOT%" (
    mkdir "%DEST_ROOT%"
    echo Main directory created: %DEST_ROOT%
)

:: Create necessary directories
echo Creating directory structure...
mkdir "%DEST_ROOT%\.ollama" 2>nul
mkdir "%DEST_ROOT%\.ollama\models" 2>nul
mkdir "%DEST_ROOT%\.ollama\models\blobs" 2>nul
mkdir "%DEST_ROOT%\AppData\Local\Ollama" 2>nul
mkdir "%DEST_ROOT%\AppData\Local\Ollama\updates" 2>nul
mkdir "%DEST_ROOT%\Programs\Ollama" 2>nul
mkdir "%DEST_ROOT%\Programs\Ollama\lib\ollama" 2>nul

echo.
echo Copying files and directories...
echo Using Ollama from: %OLLAMA_INSTALL_PATH%
echo.

:: Copy .ollama contents (if exists)
if exist "%USERPROFILE%\.ollama" (
    echo Copying .ollama directory...
    robocopy "%USERPROFILE%\.ollama" "%DEST_ROOT%\.ollama" /E /NFL /NDL /NJH /NJS /NC /NS /NP
)

:: Copy AppData\Local\Ollama contents (if exists)
if exist "%LOCALAPPDATA%\Ollama" (
    echo Copying AppData files...
    robocopy "%LOCALAPPDATA%\Ollama" "%DEST_ROOT%\AppData\Local\Ollama" /E /NFL /NDL /NJH /NJS /NC /NS /NP
)

:: Copy Programs\Ollama contents
echo Copying Program files...
robocopy "%OLLAMA_INSTALL_PATH%" "%DEST_ROOT%\Programs\Ollama" /E /NFL /NDL /NJH /NJS /NC /NS /NP

echo.
echo Creating README.txt...
(
echo Ollama Portable
echo ==============
echo.
echo To use this portable version:
echo 1. Make sure Ollama is not running
echo 2. Copy the entire folder to your desired location
echo 3. Run run_ollama.bat from the new location
echo.
echo Notes: 
echo - The portable version keeps its own config and models
echo - Ensure you have necessary permissions
echo - Can be run from a USB 3.0+ drive
) > "%DEST_ROOT%\README.txt"

echo.
echo Process completed!
echo Created in: %DEST_ROOT%
echo Please read README.txt for instructions
pause