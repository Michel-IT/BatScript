@echo off
REM all_in_one.bat - Script unificato per OpenWebUI
:menu
cls
echo ===================================
echo      OpenWebUI - Menu Principale
echo ===================================
echo 1. Avvia Open WebUI
echo 2. Installa Open WebUI
echo 3. Aggiorna Open WebUI
echo 4. Disattiva ambiente virtuale
echo 5. Disinstalla Open WebUI
echo 6. Esci
echo ===================================
choice /c 123456 /n /m "Seleziona un'opzione (1-6): "
if errorlevel 6 goto :eof
if errorlevel 5 goto uninstall
if errorlevel 4 goto deactivate
if errorlevel 3 goto update
if errorlevel 2 goto install
if errorlevel 1 goto run

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
goto menu

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

:update
echo.
echo ===================================
echo Aggiornamento di OpenWebUI...
echo ===================================
echo Attivazione ambiente virtuale...
call conda activate openwebui

echo Aggiornamento OpenWebUI...
call pip install --upgrade open-webui

echo.
echo Aggiornamento completato con successo!
pause
goto menu

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
