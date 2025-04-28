@echo off
title Ottimizzazione Windows 10 per Gaming
echo Creazione script di ottimizzazioni Windows 10 per Gaming

:: ============================================================================
:: CONFIGURAZIONE DELLE OPZIONI - Imposta a 1 per attivare, 0 per disattivare
:: ============================================================================
:: NOTA: Tutte le ottimizzazioni sono disattivate di default (0)
::       Modificare i valori in base alle proprie esigenze

:: Disattiva completamente Windows Defender 
:: ATTENZIONE: Migliora le prestazioni ma elimina la protezione antivirus
set DISABLE_DEFENDER=0

:: Disattiva Hyper-V (Virtualizzazione)
:: ATTENZIONE: Migliora le prestazioni nei giochi ma disabilita la virtualizzazione
set DISABLE_HYPERV=0

:: Disinstalla le app preinstallate di Windows (Bloatware)
:: Rimuove app preinstallate non essenziali
set REMOVE_BLOATWARE=0

:: Disattiva tutti gli effetti visivi
:: Imposta l'interfaccia per massime prestazioni con aspetto minimale
set DISABLE_ALL_VISUAL_EFFECTS=0

:: Disattiva servizi di Windows non essenziali per il gaming
:: Riduce i processi in background, può influire su alcune funzionalità
set DISABLE_NONESSENTIAL_SERVICES=0

:: Disattiva Xbox Game Bar e servizi correlati
:: Migliora le prestazioni ma disabilita le funzionalità Xbox
set DISABLE_XBOX_FEATURES=0

:: Disattiva aggiornamenti NTFS (accesso all'ultima modifica)
:: Riduce l'I/O del disco ma può influire su alcune funzionalità
set DISABLE_NTFS_UPDATES=0

:: ============================================================================
:: NON MODIFICARE IL CODICE SOTTO QUESTA LINEA A MENO CHE NON SI SIA ESPERTI
:: ============================================================================

echo Creazione punto di ripristino...

:: Creazione punto di ripristino
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Prima dell'ottimizzazione gaming", 100, 7

:: Impostare profilo energetico a prestazioni elevate
echo Configurazione profilo energetico a prestazioni elevate...
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /setactive SCHEME_MIN

:: Pianificazione Windows Defender - Esegui solo quando inattivo
echo Configurazione pianificazione Windows Defender...
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /ENABLE /IDLE /f
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /ENABLE /IDLE /f
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /ENABLE /IDLE /f
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /ENABLE /IDLE /f

:: Disabilitare telemetria e Experience
echo Disattivazione telemetria e programmi di esperienza utente...
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f

:: Disabilitare servizi non necessari per gaming
echo Configurazione servizi di sistema...
sc stop DiagTrack
sc config DiagTrack start= disabled

:: Disattivare servizio ricerca Windows
echo Disattivazione servizio Windows Search...
sc stop WSearch
sc config WSearch start= disabled

:: Disattivare SysMain (Superfetch)
echo Disattivazione Superfetch (SysMain)...
sc stop SysMain
sc config SysMain start= disabled

if "%DISABLE_NONESSENTIAL_SERVICES%"=="1" (
    echo Disattivazione servizi non essenziali...
    sc config SCardSvr start= disabled
    sc config SharedAccess start= disabled
    sc config WMPNetworkSvc start= disabled
    sc config RetailDemo start= disabled
    sc config lfsvc start= disabled
    sc config wisvc start= disabled
    sc config WpnService start= disabled
)

:: Disattivare aggiornamenti NTFS
if "%DISABLE_NTFS_UPDATES%"=="1" (
    echo Disattivazione aggiornamenti NTFS...
    fsutil behavior set disablelastaccess 1
)

:: Disattivare notifiche
echo Disattivazione notifiche...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f

:: Disabilitare effetti di trasparenza
echo Configurazione effetti visivi...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f

:: Ottimizzare prestazioni visive
if "%DISABLE_ALL_VISUAL_EFFECTS%"=="1" (
    echo Disattivazione completa degli effetti visivi...
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f
    reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f
) else (
    echo Ottimizzazione effetti visivi per prestazioni...
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "2" /f
    reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "1" /f
    reg add "HKCU\Control Panel\Desktop" /v "FontSmoothing" /t REG_SZ /d "2" /f
)

:: Disabilitare Hyper-V
if "%DISABLE_HYPERV%"=="1" (
    echo Disattivazione Hyper-V...
    dism /Online /Disable-Feature /FeatureName:Microsoft-Hyper-V-All /NoRestart
)

:: Disabilitare Windows Defender
if "%DISABLE_DEFENDER%"=="1" (
    echo Disattivazione Windows Defender...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f
)

:: Disabilitare funzionalità Xbox
if "%DISABLE_XBOX_FEATURES%"=="1" (
    echo Disattivazione servizi Xbox...
    sc config XblAuthManager start= disabled
    sc config XblGameSave start= disabled
    sc config XboxNetApiSvc start= disabled
    sc config XboxGipSvc start= disabled
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\xbgm" /v "Start" /t REG_DWORD /d "4" /f
)

:: Rimuovere bloatware
if "%REMOVE_BLOATWARE%"=="1" (
    echo Rimozione app preinstallate (Bloatware)...
    powershell -Command "Get-AppxPackage *3dbuilder* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *windowsalarms* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *windowscamera* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *officehub* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *skypeapp* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *getstarted* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *zunemusic* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *windowsmaps* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *solitairecollection* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *bingfinance* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *zunevideo* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *bingnews* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *onenote* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *people* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *windowsphone* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *photos* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *bingsports* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *soundrecorder* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *bingweather* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *xboxapp* | Remove-AppxPackage"
)

:: Ottimizzare mouse
echo Ottimizzazione impostazioni mouse per gaming...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "0000000000000000c0cc0c0000000000809919000000000040662600000000000033330000000000" /f
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "0000000000000000000038000000000000007000000000000000a800000000000000e00000000000" /f

:: Attivare modalità gioco
echo Attivazione modalità gioco...
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "1" /f

:: Disabilitare Game Bar e registrazione gameplay
echo Disattivazione Game DVR e Game Bar...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f

echo.
echo Ottimizzazioni completate. Si consiglia di riavviare il sistema.
echo.
echo AVVISO: Alcune modifiche potrebbero richiedere un riavvio per essere applicate correttamente.
echo.
echo NOTA: Per priorità di processo nei giochi, utilizzare Task Manager (Gestione attività).
echo       Premere CTRL+SHIFT+ESC durante il gioco, tasto destro sul processo del gioco, 
echo       Imposta priorità -> Alta
echo.
pause