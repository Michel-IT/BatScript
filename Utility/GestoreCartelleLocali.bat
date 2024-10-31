@echo off
setlocal EnableDelayedExpansion

:menu
cls
echo ===================================
echo    GESTIONE CARTELLE
echo    Directory corrente: %~dp0
echo ===================================
echo.
echo Cosa vuoi fare?
echo.
echo M. Mostra una cartella (inserisci il numero)
echo N. Nascondi una cartella (inserisci il numero)
echo R. Ricarica lista
echo E. Esci
echo.
echo ===================================
echo Cartelle in questa directory:
echo [H] = Nascosta  [V] = Visibile
echo ===================================
echo.

rem Crea un file temporaneo per memorizzare le cartelle
del /q "%temp%\folders.txt" 2>nul
set count=0

rem Elenca tutte le cartelle con il loro stato
for /f "tokens=*" %%F in ('dir /b /ad 2^>nul') do (
    set /a count+=1
    set "folder=%%F"
    
    rem Controlla se la cartella è nascosta
    dir /a:h "%%F" >nul 2>&1
    if !errorlevel! equ 0 (
        echo !count!. [H] %%F
    ) else (
        echo !count!. [V] %%F
    )
    echo %%F>>"%temp%\folders.txt"
)

if %count%==0 (
    echo Nessuna cartella trovata in questa directory!
    echo.
    pause
    goto menu
)

echo.
SET /P azione=Inserisci la tua scelta: 

if /i "!azione!"=="E" goto esci
if /i "!azione!"=="R" goto menu
if /i "!azione!"=="N" (
    SET /P numero=Inserisci il numero della cartella da nascondere: 
    call :nascondi_cartella !numero!
    goto menu
)
if /i "!azione!"=="M" (
    SET /P numero=Inserisci il numero della cartella da mostrare: 
    call :mostra_cartella !numero!
    goto menu
)
goto menu

:mostra_cartella
set n=0
for /f "tokens=*" %%a in ('type "%temp%\folders.txt"') do (
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

:nascondi_cartella
set n=0
for /f "tokens=*" %%a in ('type "%temp%\folders.txt"') do (
    set /a n+=1
    if !n!==%~1 (
        attrib +h +s "%%a"
        echo.
        echo La cartella "%%a" è stata nascosta!
        pause
        exit /b
    )
)
echo.
echo Numero non valido!
pause
exit /b

:esci
echo.
echo Grazie per aver usato il programma!
del /q "%temp%\folders.txt" 2>nul
timeout /t 2 >nul
exit