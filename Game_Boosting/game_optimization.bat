@echo off
setlocal enabledelayedexpansion

:: Multilingual Interactive Gaming and Network Optimization Script
:: Version: 1.0
:: Last Updated: 2025-05-05

:: Initialize optimization flags
set "NETWORK_TCP_ACK_FREQ=0"
set "NETWORK_TCP_NO_DELAY=0"
set "NETWORK_TCP_DELACK_TICKS=0"
set "NETWORK_GLOBAL_TWEAKS=0"
set "SYSTEM_DISABLE_DEFENDER=0"
set "SYSTEM_DISABLE_SERVICES=0"
set "SYSTEM_DISABLE_TELEMETRY=0"
set "SYSTEM_DISABLE_NOTIFICATIONS=0"
set "GAMING_VISUAL_EFFECTS=0"
set "GAMING_POWER_PLAN=0"
set "GAMING_MOUSE_OPTIMIZATION=0"
set "GAMING_GAME_MODE=0"
set "GAMING_DISABLE_GAME_DVR=0"
set "SYSTEM_DISABLE_CORE_ISOLATION=0"
set "GAMING_XBOX_FEATURES=0"

:: Initialize network interface variables
set "SELECTED_GUID="
set "SELECTED_IP="

:language_selection
cls
echo ========================================
echo Select Language / Seleziona Lingua
echo ========================================
echo 1. English
echo 2. Italiano
set /p lang_choice="Enter your choice (1/2): "

if "%lang_choice%"=="1" (
    set "LANGUAGE=EN"
    set "TITLE_MAIN=Windows Gaming and Network Optimization"
    set "MSG_SELECT_OPTIMIZATION=Select optimizations to apply"
    set "MSG_NETWORK_TWEAKS=Network Performance Tweaks"
    set "MSG_SYSTEM_TWEAKS=System Performance Tweaks"
    set "MSG_GAMING_TWEAKS=Gaming Performance Tweaks"
    set "MSG_NETWORK_INTERFACES=Network Interface Selection"
    set "MSG_LIST_INTERFACES=Listing available network interfaces (Name + GUID + IP)"
    set "MSG_SELECT_INTERFACE=Select the interface number to optimize"
    set "MSG_SELECTED_INTERFACE=Selected Interface"
    set "MSG_NO_INTERFACES=No network interfaces found"
    set "MSG_CONFIRM=Do you want to enable this optimization?"
    set "MSG_ENABLED=Optimization enabled"
    set "MSG_SKIPPED=Optimization skipped"
    set "MSG_RESTORE_POINT=Creating system restore point"
    set "MSG_RESTORE_POINT_CONFIRM=Do you want to create a system restore point before applying changes?"
    set "MSG_APPLY=Applying optimizations"
    set "MSG_SUCCESS=Optimizations applied successfully"
    set "MSG_REBOOT=Reboot recommended for full effect"
    set "MSG_RESET=Reset All Settings"
    set "MSG_CONFIRM_EACH=Confirm each operation"
) else if "%lang_choice%"=="2" (
    set "LANGUAGE=IT"
    set "TITLE_MAIN=Ottimizzazione Gaming e Rete Windows"
    set "MSG_SELECT_OPTIMIZATION=Seleziona le ottimizzazioni da applicare"
    set "MSG_NETWORK_TWEAKS=Ottimizzazioni Prestazioni Rete"
    set "MSG_SYSTEM_TWEAKS=Ottimizzazioni Prestazioni Sistema"
    set "MSG_GAMING_TWEAKS=Ottimizzazioni Prestazioni Gaming"
    set "MSG_NETWORK_INTERFACES=Selezione Interfaccia di Rete"
    set "MSG_LIST_INTERFACES=Elenco delle interfacce di rete disponibili (Nome + GUID + IP)"
    set "MSG_SELECT_INTERFACE=Seleziona il numero dell'interfaccia da ottimizzare"
    set "MSG_SELECTED_INTERFACE=Interfaccia Selezionata"
    set "MSG_NO_INTERFACES=Nessuna interfaccia di rete trovata"
    set "MSG_CONFIRM=Vuoi abilitare questa ottimizzazione?"
    set "MSG_ENABLED=Ottimizzazione abilitata"
    set "MSG_SKIPPED=Ottimizzazione saltata"
    set "MSG_RESTORE_POINT=Creazione punto di ripristino"
    set "MSG_RESTORE_POINT_CONFIRM=Vuoi creare un punto di ripristino prima di applicare le modifiche?"
    set "MSG_APPLY=Applicazione ottimizzazioni"
    set "MSG_SUCCESS=Ottimizzazioni applicate con successo"
    set "MSG_REBOOT=Si consiglia di riavviare per applicare completamente le modifiche"
    set "MSG_RESET=Ripristina Tutte le Impostazioni"
    set "MSG_CONFIRM_EACH=Conferma ogni operazione"
) else (
    goto language_selection
)

:windows_version
cls
echo ========================================
echo Select Windows Version / Seleziona Versione Windows
echo ========================================
echo 1. Windows 10
echo 2. Windows 11
set /p win_choice="Enter your choice (1/2): "

if "%win_choice%"=="1" set "WINDOWS_VERSION=10"
if "%win_choice%"=="2" set "WINDOWS_VERSION=11"
if not defined WINDOWS_VERSION goto windows_version

:: Ask for system restore point creation at the beginning
cls
echo ========================================
echo %MSG_RESTORE_POINT_CONFIRM%
echo ========================================
echo.
set /p restore_confirm="(Y/N): "
if /i "%restore_confirm%"=="Y" (
    echo %MSG_RESTORE_POINT%...
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Before Game Optimization" 100 7
    echo.
    echo System restore point created successfully.
    pause
)

:select_network_interface
cls
echo ========================================
echo %MSG_NETWORK_INTERFACES%
echo ========================================
echo %MSG_LIST_INTERFACES%:
echo.

:: Collect network interfaces
set "interface_count=0"
for /f "tokens=1,2* delims={}" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"') do (
    set "key=%%B"
    for /f "tokens=2*" %%C in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\{%%B}" /v DhcpIPAddress 2^>nul ^| find "REG_SZ"') do (
        set /a "interface_count+=1"
        set "interface_!interface_count!_guid={%%B}"
        set "interface_!interface_count!_ip=%%D"
        echo !interface_count!. GUID: {%%B} - IP: %%D
    )
)

if %interface_count% equ 0 (
    echo %MSG_NO_INTERFACES%
    pause
    goto windows_version
)

echo.
set /p interface_choice="%MSG_SELECT_INTERFACE% (1-%interface_count%): "

if %interface_choice% lss 1 set interface_choice=1
if %interface_choice% gtr %interface_count% set interface_choice=%interface_count%

set "SELECTED_GUID=!interface_%interface_choice%_guid!"
set "SELECTED_IP=!interface_%interface_choice%_ip!"

echo %MSG_SELECTED_INTERFACE%: GUID !SELECTED_GUID! - IP !SELECTED_IP!
echo.
pause

:main_menu
cls
echo ========================================
echo %TITLE_MAIN%
echo ========================================
echo %MSG_SELECT_OPTIMIZATION%:
echo.
echo 1. %MSG_NETWORK_TWEAKS%
echo 2. %MSG_SYSTEM_TWEAKS%
echo 3. %MSG_GAMING_TWEAKS%
echo 4. Apply Selected Optimizations
echo 5. Change Network Interface
echo 6. %MSG_RESET%
echo 7. Exit
set /p menu_choice="Select an option (1-7): "

if "%menu_choice%"=="1" goto network_tweaks
if "%menu_choice%"=="2" goto system_tweaks
if "%menu_choice%"=="3" goto gaming_tweaks
if "%menu_choice%"=="4" goto apply_optimizations
if "%menu_choice%"=="5" goto select_network_interface
if "%menu_choice%"=="6" goto reset_settings
if "%menu_choice%"=="7" exit /b

:network_tweaks
cls
echo ========================================
echo %MSG_NETWORK_TWEAKS%
echo ========================================

if "%LANGUAGE%"=="EN" (
    call :show_tweak "TCP_ACK_FREQ" ^
        "Reduces network packet acknowledgment overhead" ^
        "Potentially improves network responsiveness" ^
        "Minimal system impact" ^
        NETWORK_TCP_ACK_FREQ
    
    call :show_tweak "TCP_NO_DELAY" ^
        "Reduces network latency by sending packets immediately" ^
        "Improves real-time network performance" ^
        "Beneficial for online gaming and streaming" ^
        NETWORK_TCP_NO_DELAY
        
    call :show_tweak "TCP_DELACK_TICKS" ^
        "Controls delayed ACK behavior for network efficiency" ^
        "Optimizes packet acknowledgment timing" ^
        "Can reduce latency in gaming scenarios" ^
        NETWORK_TCP_DELACK_TICKS
        
    call :show_tweak "GLOBAL_TCP_TWEAKS" ^
        "Applies global TCP/IP optimizations to all interfaces" ^
        "Includes autotuninglevel, congestionprovider, dca, rss" ^
        "Improves overall network performance" ^
        NETWORK_GLOBAL_TWEAKS
) else (
    call :show_tweak "TCP_ACK_FREQ" ^
        "Riduce l'overhead dei pacchetti di acknowledgment di rete" ^
        "Potenzialmente migliora la reattività di rete" ^
        "Impatto minimo sul sistema" ^
        NETWORK_TCP_ACK_FREQ
    
    call :show_tweak "TCP_NO_DELAY" ^
        "Riduce la latenza di rete inviando pacchetti immediatamente" ^
        "Migliora le prestazioni di rete in tempo reale" ^
        "Vantaggioso per gaming online e streaming" ^
        NETWORK_TCP_NO_DELAY
        
    call :show_tweak "TCP_DELACK_TICKS" ^
        "Controlla il comportamento degli ACK ritardati per l'efficienza di rete" ^
        "Ottimizza la tempistica di acknowledgment dei pacchetti" ^
        "Può ridurre la latenza negli scenari di gaming" ^
        NETWORK_TCP_DELACK_TICKS
        
    call :show_tweak "GLOBAL_TCP_TWEAKS" ^
        "Applica ottimizzazioni TCP/IP globali a tutte le interfacce" ^
        "Include autotuninglevel, congestionprovider, dca, rss" ^
        "Migliora le prestazioni di rete complessive" ^
        NETWORK_GLOBAL_TWEAKS
)

goto main_menu

:system_tweaks
cls
echo ========================================
echo %MSG_SYSTEM_TWEAKS%
echo ========================================

if "%LANGUAGE%"=="EN" (
    call :show_tweak "DISABLE_DEFENDER" ^
        "Completely turns off Windows built-in antivirus" ^
        "Reduces system resource usage" ^
        "CAUTION: Significantly increases security risks" ^
        SYSTEM_DISABLE_DEFENDER
    
    call :show_tweak "DISABLE_SERVICES" ^
        "Stops non-essential Windows services" ^
        "Frees up system resources" ^
        "May disable some system functionalities" ^
        SYSTEM_DISABLE_SERVICES
        
    call :show_tweak "DISABLE_TELEMETRY" ^
        "Disables Windows telemetry and data collection" ^
        "Improves privacy and reduces background processes" ^
        "No significant drawbacks for most users" ^
        SYSTEM_DISABLE_TELEMETRY
        
    call :show_tweak "DISABLE_NOTIFICATIONS" ^
        "Turns off Windows notifications" ^
        "Reduces distractions during gaming" ^
        "You won't receive system notifications" ^
        SYSTEM_DISABLE_NOTIFICATIONS
) else (
    call :show_tweak "DISABLE_DEFENDER" ^
        "Disattiva completamente l'antivirus integrato di Windows" ^
        "Riduce l'utilizzo delle risorse di sistema" ^
        "ATTENZIONE: Aumenta significativamente i rischi di sicurezza" ^
        SYSTEM_DISABLE_DEFENDER
    
    call :show_tweak "DISABLE_SERVICES" ^
        "Ferma i servizi di Windows non essenziali" ^
        "Libera risorse di sistema" ^
        "Può disabilitare alcune funzionalità di sistema" ^
        SYSTEM_DISABLE_SERVICES
        
    call :show_tweak "DISABLE_TELEMETRY" ^
        "Disattiva la telemetria e la raccolta dati di Windows" ^
        "Migliora la privacy e riduce i processi in background" ^
        "Nessun inconveniente significativo per la maggior parte degli utenti" ^
        SYSTEM_DISABLE_TELEMETRY
        
    call :show_tweak "DISABLE_NOTIFICATIONS" ^
        "Disattiva le notifiche di Windows" ^
        "Riduce le distrazioni durante il gaming" ^
        "Non riceverai notifiche di sistema" ^
        SYSTEM_DISABLE_NOTIFICATIONS
)

goto main_menu

:gaming_tweaks
cls
echo ========================================
echo %MSG_GAMING_TWEAKS%
echo ========================================

if "%LANGUAGE%"=="EN" (
    call :show_tweak "VISUAL_EFFECTS" ^
        "Reduces graphical system overhead" ^
        "Improves overall system responsiveness" ^
        "Slightly reduces visual quality" ^
        GAMING_VISUAL_EFFECTS
    
    call :show_tweak "HIGH_PERFORMANCE_PLAN" ^
        "Sets system to maximum performance mode" ^
        "Maximizes CPU and GPU performance" ^
        "Increases power consumption" ^
        GAMING_POWER_PLAN
        
    call :show_tweak "MOUSE_OPTIMIZATION" ^
        "Optimizes mouse settings for gaming" ^
        "Disables acceleration and smoothing" ^
        "Provides more precise mouse control" ^
        GAMING_MOUSE_OPTIMIZATION
        
    call :show_tweak "GAME_MODE" ^
        "Enables Windows Game Mode" ^
        "Prioritizes system resources for games" ^
        "May improve frame rates in some games" ^
        GAMING_GAME_MODE
        
    call :show_tweak "DISABLE_GAME_DVR" ^
        "Disables Game Bar and Game DVR" ^
        "Reduces overhead during gaming" ^
        "You won't be able to record gameplay" ^
        GAMING_DISABLE_GAME_DVR
) else (
    call :show_tweak "VISUAL_EFFECTS" ^
        "Riduce l'overhead grafico del sistema" ^
        "Migliora la reattività complessiva del sistema" ^
        "Riduce leggermente la qualità visiva" ^
        GAMING_VISUAL_EFFECTS
    
    call :show_tweak "HIGH_PERFORMANCE_PLAN" ^
        "Imposta il sistema in modalità prestazioni massime" ^
        "Massimizza le prestazioni di CPU e GPU" ^
        "Aumenta il consumo energetico" ^
        GAMING_POWER_PLAN
        
    call :show_tweak "MOUSE_OPTIMIZATION" ^
        "Ottimizza le impostazioni del mouse per il gaming" ^
        "Disabilita accelerazione e smoothing" ^
        "Fornisce un controllo del mouse più preciso" ^
        GAMING_MOUSE_OPTIMIZATION
        
    call :show_tweak "GAME_MODE" ^
        "Abilita la modalità gioco di Windows" ^
        "Dà priorità alle risorse di sistema per i giochi" ^
        "Può migliorare il frame rate in alcuni giochi" ^
        GAMING_GAME_MODE
        
    call :show_tweak "DISABLE_GAME_DVR" ^
        "Disabilita Game Bar e Game DVR" ^
        "Riduce l'overhead durante il gaming" ^
        "Non potrai registrare il gameplay" ^
        GAMING_DISABLE_GAME_DVR
)

goto main_menu

:show_tweak
setlocal
set "name=%~1"
set "description=%~2"
set "pro=%~3"
set "impact=%~4"
set "current_var=%~5"

echo.
echo %name%
echo ----------------------------------------
echo %description%
echo %pro%
echo %impact%
echo.

if "!%current_var%!"=="1" (
    set /p choice="%MSG_CONFIRM% (Y/N) [Currently ON]: "
) else (
    set /p choice="%MSG_CONFIRM% (Y/N) [Currently OFF]: "
)

if /i "!choice!"=="Y" (
    set "!current_var!=1"
    echo %MSG_ENABLED%: %name%
) else (
    set "!current_var!=0"
    echo %MSG_SKIPPED%: %name%
)
endlocal
exit /b

:apply_optimizations
cls
echo ========================================
echo Applying Selected Optimizations
echo ========================================


:: Check if network interface is selected
if not defined SELECTED_GUID (
    echo No network interface selected. Please select a network interface first.
    pause
    goto select_network_interface
)

:: Network Optimizations
if %NETWORK_TCP_ACK_FREQ%==1 (
    echo Applying TCP ACK Frequency Reduction to interface %SELECTED_GUID%...
    netsh int tcp set global autotuninglevel=disabled
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%SELECTED_GUID%" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f
) else (
    reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%SELECTED_GUID%" /v "TcpAckFrequency" /f 2>nul
)

if %NETWORK_TCP_NO_DELAY%==1 (
    echo Applying TCP No Delay to interface %SELECTED_GUID%...
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%SELECTED_GUID%" /v "TCPNoDelay" /t REG_DWORD /d 1 /f
) else (
    reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%SELECTED_GUID%" /v "TCPNoDelay" /f 2>nul
)

if %NETWORK_TCP_DELACK_TICKS%==1 (
    echo Applying TCP DelAck Ticks optimization to interface %SELECTED_GUID%...
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%SELECTED_GUID%" /v "TcpDelAckTicks" /t REG_DWORD /d 0 /f
) else (
    reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%SELECTED_GUID%" /v "TcpDelAckTicks" /f 2>nul
)

:: Global TCP/IP Optimizations
if %NETWORK_GLOBAL_TWEAKS%==1 (
    echo Applying global TCP/IP optimizations...
    netsh int tcp set global autotuninglevel=disabled
    netsh int tcp set global congestionprovider=none
    netsh int tcp set global dca=enabled
    netsh int tcp set global rss=enabled
)

:: System Optimizations
if %SYSTEM_DISABLE_DEFENDER%==1 (
    echo Disabling Windows Defender...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
    sc stop WinDefend
    sc config WinDefend start= disabled
)

if %SYSTEM_DISABLE_SERVICES%==1 (
    echo Stopping non-essential services...
    sc stop DiagTrack
    sc config DiagTrack start= disabled
    sc stop WSearch
    sc config WSearch start= disabled
    sc stop SysMain
    sc config SysMain start= disabled
)

if %SYSTEM_DISABLE_TELEMETRY%==1 (
    echo Disabling telemetry and data collection...
    schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
    schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
    schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable
    schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
    schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
    reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
)

if %SYSTEM_DISABLE_NOTIFICATIONS%==1 (
    echo Disabling notifications...
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f
)

:: Gaming Optimizations
if %GAMING_VISUAL_EFFECTS%==1 (
    echo Optimizing Visual Effects...
    :: Set to custom visual effects
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 3 /f
    
    :: Disable all visual effects except the two we want to keep
    reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f
    
    :: Enable only "Show window contents while dragging"
    reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "1" /f
    
    :: Enable only "Smooth edges of screen fonts"
    reg add "HKCU\Control Panel\Desktop" /v "FontSmoothing" /t REG_SZ /d "2" /f
    
    :: Disable transparency
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f
    
    :: Disable animation effects
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d "0" /f
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f
    
    :: Disable menu animations
    reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f
)

if %GAMING_POWER_PLAN%==1 (
    echo Setting High Performance Power Plan...
    powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
)

if %GAMING_MOUSE_OPTIMIZATION%==1 (
    echo Optimizing mouse settings for gaming...
    reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f
    reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f
    reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f
    reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f
    reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "0000000000000000c0cc0c0000000000809919000000000040662600000000000033330000000000" /f
    reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "0000000000000000000038000000000000007000000000000000a800000000000000e00000000000" /f
)

if %GAMING_GAME_MODE%==1 (
    echo Enabling Game Mode...
    reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "1" /f
    reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "1" /f
)

if %GAMING_DISABLE_GAME_DVR%==1 (
    echo Disabling Game DVR and Game Bar...
    reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "HistoricalCaptureEnabled" /t REG_DWORD /d "0" /f
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f
)

:: Windows Version Specific Optimizations
if "%WINDOWS_VERSION%"=="11" (
    if %SYSTEM_DISABLE_CORE_ISOLATION%==1 (
        echo Disabling Core Isolation...
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d 0 /f
    )
)

if "%WINDOWS_VERSION%"=="10" (
    if %GAMING_XBOX_FEATURES%==1 (
        echo Disabling Xbox Features...
        sc config XblAuthManager start= disabled
        sc config XblGameSave start= disabled
    )
)

echo.
echo ========================================
echo %MSG_SUCCESS%
echo %MSG_REBOOT%
echo ========================================
pause
goto main_menu

:reset_settings
cls
echo ========================================
echo %MSG_RESET%
echo ========================================
echo.
set /p reset_confirm="Are you sure you want to reset all settings? (Y/N): "
if /i not "%reset_confirm%"=="Y" goto main_menu

:: Reset all optimization flags
set "NETWORK_TCP_ACK_FREQ=0"
set "NETWORK_TCP_NO_DELAY=0"
set "NETWORK_TCP_DELACK_TICKS=0"
set "NETWORK_GLOBAL_TWEAKS=0"
set "SYSTEM_DISABLE_DEFENDER=0"
set "SYSTEM_DISABLE_SERVICES=0"
set "SYSTEM_DISABLE_TELEMETRY=0"
set "SYSTEM_DISABLE_NOTIFICATIONS=0"
set "GAMING_VISUAL_EFFECTS=0"
set "GAMING_POWER_PLAN=0"
set "GAMING_MOUSE_OPTIMIZATION=0"
set "GAMING_GAME_MODE=0"
set "GAMING_DISABLE_GAME_DVR=0"
set "SYSTEM_DISABLE_CORE_ISOLATION=0"
set "GAMING_XBOX_FEATURES=0"

echo All settings have been reset to default.
pause
goto main_menu


exit /b
