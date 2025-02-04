@echo off
REM all_in_one.bat - Script unificato per OpenWebUI
:menu
cls
echo ===================================
echo      OpenWebUI - Menu Principale
echo ===================================
echo 1. Installa Open WebUI
echo 2. Avvia Open WebUI
echo 3. Disattiva ambiente virtuale
echo 4. Disinstalla Open WebUI
echo 5. Esci
echo ===================================
choice /c 12345 /n /m "Seleziona un'opzione (1-5): "
if errorlevel 5 goto :eof
if errorlevel 4 goto uninstall
if errorlevel 3 goto deactivate
if errorlevel 2 goto run
if errorlevel 1 goto install

:install
echo.
echo Inizializzazione installazione OpenWebUI...
echo ===================================

REM Verifica se winget è installato
where winget >nul 2>nul
if %errorlevel% neq 0 (
    echo ATTENZIONE: winget non è installato sul sistema.
    echo L'installazione continuerà usando solo conda per FFmpeg.
    goto skip_winget
)

REM Installazione FFmpeg tramite winget
echo Installazione FFmpeg tramite winget...
winget install "FFmpeg (Essentials Build)"

:skip_winget
REM Creazione ambiente virtuale
echo Creazione ambiente virtuale Python...
conda create -n openwebui python=3.11 -y
echo Attivazione ambiente virtuale...
call conda activate openwebui
echo Installazione FFmpeg in conda...
::call conda install -c conda-forge ffmpeg -y
echo Installazione OpenWebUI...
call pip install open-webui
echo.
echo Installazione completata con successo!
pause
goto menu

:run
echo.
echo ===================================
echo Avvio OpenWebUI...
echo Per terminare l'applicazione, premere CTRL+C
echo ===================================
start http://localhost:8080
conda activate openwebui && open-webui serve
cmd /k
pause

:deactivate
echo.
echo Disattivazione ambiente virtuale...
conda deactivate
echo Ambiente virtuale disattivato con successo
pause
goto menu

:uninstall
echo.
echo ===================================
echo Disinstallazione OpenWebUI
echo ===================================
echo ATTENZIONE: Questa operazione rimuoverà l'ambiente virtuale e tutti i pacchetti installati.
choice /c SN /n /m "Sei sicuro di voler procedere? (S/N): "
if errorlevel 2 goto menu

echo.
echo Disattivazione ambiente virtuale...
call conda deactivate

echo Rimozione ambiente virtuale...
call conda remove -n openwebui --all -y

echo.
echo Disinstallazione completata con successo!
pause
goto menu
