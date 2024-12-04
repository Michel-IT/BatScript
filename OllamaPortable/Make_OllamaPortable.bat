@echo off
setlocal enabledelayedexpansion

echo Creating Portable Version of OllamaPortable
echo =========================================

:: Set source and destination paths
set "SOURCE_ROOT=%LOCALAPPDATA%"
set "DEST_ROOT=C:\OllamaPortable"

:: Create main directory if it doesn't exist
if not exist "%DEST_ROOT%" (
    mkdir "%DEST_ROOT%"
    echo Main directory created: %DEST_ROOT%
)

:: Create necessary directories
mkdir "%DEST_ROOT%\.ollama" 2>nul
mkdir "%DEST_ROOT%\.ollama\models" 2>nul
mkdir "%DEST_ROOT%\.ollama\models\blobs" 2>nul
mkdir "%DEST_ROOT%\AppData\Local\Ollama" 2>nul
mkdir "%DEST_ROOT%\AppData\Local\Ollama\updates" 2>nul
mkdir "%DEST_ROOT%\Programs\Ollama" 2>nul
mkdir "%DEST_ROOT%\Programs\Ollama\lib\ollama" 2>nul

echo.
echo Copying files and directories...

:: Copy .ollama contents
robocopy "%USERPROFILE%\.ollama" "%DEST_ROOT%\.ollama" /E /NFL /NDL /NJH /NJS /NC /NS /NP

:: Copy AppData\Local\Ollama contents
robocopy "%LOCALAPPDATA%\Ollama" "%DEST_ROOT%\AppData\Local\Ollama" /E /NFL /NDL /NJH /NJS /NC /NS /NP

:: Copy Programs\Ollama contents
robocopy "C:\Program Files\Ollama" "%DEST_ROOT%\Programs\Ollama" /E /NFL /NDL /NJH /NJS /NC /NS /NP

echo.
echo Creating README.txt with instructions...
(
echo Ollama Portable
echo ===============
echo.
echo To use this portable version:
echo 1. Make sure Ollama is not running
echo 2. Copy the entire ollama folder to your desired location
echo 3. Update environment variables to point to the new location
echo.
echo Notes: 
echo - You may need to update paths in configuration files
echo - Ensure you have necessary permissions in the new location
) > "%DEST_ROOT%\README.txt"

echo.
echo Process completed!
echo The portable version of Ollama has been created in: %DEST_ROOT%
echo For instructions, read the README.txt file in the main directory
pause