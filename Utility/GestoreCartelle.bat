@echo off
setlocal EnableDelayedExpansion

:menu
cls
echo ===================================
echo    GESTIONE CARTELLE NASCOSTE
echo ===================================
echo.
echo Cartelle nascoste trovate:
echo.

rem Crea un file temporaneo per memorizzare le cartelle nascoste
del /q "%temp%\hidden_folders.txt" 2>nul
set count=0

rem Cerca tutte le cartelle con attributo nascosto
for /f "tokens=*" %%F in ('dir /a:h /b /s /ad 2^>nul') do (
    set /a count+=1
    echo !count!. %%F
    echo %%F>>"%temp%\hidden_folders.txt"
)

if %count%==0 (
    echo Nessuna cartella nascosta trovata!
    echo.
    echo 1. Cerca nuove cartelle
    echo 2. Nascondi una nuova cartella
    echo 3. Esci
    echo.
    SET /P scelta=Inserisci il numero della tua scelta: 
    
    if "!scelta!"=="1" goto menu
    if "!scelta!"=="2" goto nascondi_nuova
    if "!scelta!"=="3" goto esci
    goto menu
)

echo.
echo Cosa vuoi fare?
echo.
echo M. Mostra una cartella (inserisci il numero)
echo N. Nascondi una nuova cartella
echo R. Ricarica lista
echo E. Esci
echo.
SET /P azione=Inserisci la tua scelta: 

if /i "!azione!"=="E" goto esci
if /i "!azione!"=="R" goto menu
if /i "!azione!"=="N" goto nascondi_nuova
if /i "!azione!"=="M" (
    SET /P numero=Inserisci il numero della cartella da mostrare: 
    call :mostra_cartella !numero!
    goto menu
)
goto menu

:mostra_cartella
set n=0
for /f "tokens=*" %%a in ('type "%temp%\hidden_folders.txt"') do (
    set /a n+=1
    if !n!==%~1 (
        attrib -h -s "%%a"
        echo.
        echo La cartella "%%a" è stata resa visibile!
        pause
        exit /b
    )
)
echo.
echo Numero non valido!
pause
exit /b

:nascondi_nuova
echo.
SET /P nuova_cartella=Inserisci il percorso completo della cartella da nascondere: 
if exist "!nuova_cartella!" (
    attrib +h +s "!nuova_cartella!"
    echo.
    echo La cartella è stata nascosta!
) else (
    echo.
    echo ERRORE: La cartella non esiste!
)
pause
goto menu

:esci
echo.
echo Grazie per aver usato il programma!
del /q "%temp%\hidden_folders.txt" 2>nul
timeout /t 2 >nul
exit