@echo off
title Windows 11 Gaming Optimization
echo Creating Windows 11 Gaming Optimization script
echo.

:: ============================================================================
:: CONFIGURATION OPTIONS - Set to 1 to enable, 0 to disable
:: ============================================================================
:: NOTE: All optimizations are disabled by default (0)
::       Modify values according to your needs

:: Disable Core Isolation (Memory Integrity)
:: WARNING: Improves performance but reduces system security
set DISABLE_CORE_ISOLATION=0

:: Completely disable Windows Defender 
:: WARNING: Improves performance but eliminates antivirus protection
set DISABLE_DEFENDER=0

:: Disable Hyper-V (Virtualization)
:: WARNING: Improves gaming performance but disables virtualization
set DISABLE_HYPERV=0

:: Uninstall preinstalled Windows apps (Bloatware)
:: Removes non-essential preinstalled apps
set REMOVE_BLOATWARE=0

:: Disable all visual effects
:: Sets interface for maximum performance with minimal appearance
set DISABLE_ALL_VISUAL_EFFECTS=0

:: Disable non-essential Windows services for gaming
:: Reduces background processes, may affect some functionalities
set DISABLE_NONESSENTIAL_SERVICES=0

:: Disable NTFS updates (last access time)
:: Reduces disk I/O but may affect some functionalities
set DISABLE_NTFS_UPDATES=0

:: ============================================================================
:: DO NOT MODIFY THE CODE BELOW THIS LINE UNLESS YOU ARE AN EXPERT
:: ============================================================================

echo Creating system restore point...

:: Create system restore point
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Before gaming optimization", 100, 7

:: Set high performance power profile
echo Configuring high performance power profile...
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /setactive SCHEME_MIN

:: Disable night light and HDR
echo Configuring display settings...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.bluelightreductionstate\windows.data.bluelightreduction.bluelightreductionstate" /v "Data" /t REG_BINARY /d "02000000" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\VideoSettings" /v "EnableHDRForPlayback" /t REG_DWORD /d "0" /f

:: Windows Defender scheduling - Run only when idle
echo Configuring Windows Defender scheduling...
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /ENABLE /IDLE /f
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /ENABLE /IDLE /f
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /ENABLE /IDLE /f
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /ENABLE /IDLE /f

:: Disable telemetry and Experience programs
echo Disabling telemetry and user experience programs...
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f

:: Disable unnecessary services for gaming
echo Configuring system services...
sc stop DiagTrack
sc config DiagTrack start= disabled

:: Disable Windows Search service
echo Disabling Windows Search service...
sc stop WSearch
sc config WSearch start= disabled

:: Disable SysMain (Superfetch)
echo Disabling Superfetch (SysMain)...
sc stop SysMain
sc config SysMain start= disabled

if "%DISABLE_NONESSENTIAL_SERVICES%"=="1" (
    echo Disabling non-essential services...
    sc config SCardSvr start= disabled
    sc config SharedAccess start= disabled
    sc config WMPNetworkSvc start= disabled
    sc config RetailDemo start= disabled
    sc config lfsvc start= disabled
)

:: Disable NTFS updates
if "%DISABLE_NTFS_UPDATES%"=="1" (
    echo Disabling NTFS updates...
    fsutil behavior set disablelastaccess 1
)

:: Disable notifications
echo Disabling notifications...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f

:: Disable transparency effects
echo Configuring visual effects...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f

:: Multitasking and window snapping
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d "0" /f

:: Disable Core Isolation - Memory Integrity
if "%DISABLE_CORE_ISOLATION%"=="1" (
    echo Disabling Core Isolation (Memory Integrity)...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f
)

:: Optimize visual performance
if "%DISABLE_ALL_VISUAL_EFFECTS%"=="1" (
    echo Disabling all visual effects...
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f
    reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f
) else (
    echo Optimizing visual effects for performance...
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "2" /f
    reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "1" /f
    reg add "HKCU\Control Panel\Desktop" /v "FontSmoothing" /t REG_SZ /d "2" /f
)

:: Disable Hyper-V
if "%DISABLE_HYPERV%"=="1" (
    echo Disabling Hyper-V...
    dism /Online /Disable-Feature /FeatureName:Microsoft-Hyper-V-All /NoRestart
)

:: Disable Windows Defender
if "%DISABLE_DEFENDER%"=="1" (
    echo Disabling Windows Defender...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f
)

:: Remove bloatware
if "%REMOVE_BLOATWARE%"=="1" (
    echo Removing preinstalled apps (Bloatware)...
    powershell -Command "Get-AppxPackage *3dbuilder* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *windowsalarms* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *windowscalculator* | Remove-AppxPackage"
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

:: Optimize mouse
echo Optimizing mouse settings for gaming...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "0000000000000000c0cc0c0000000000809919000000000040662600000000000033330000000000" /f
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "0000000000000000000038000000000000007000000000000000a800000000000000e00000000000" /f

:: Enable game mode
echo Activating game mode...
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "1" /f

:: Disable Game Bar and gameplay recording
echo Disabling Game DVR and Game Bar...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "HistoricalCaptureEnabled" /t REG_DWORD /d "0" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f

:: Enable GPU hardware acceleration scheduling
reg add "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "VRROptimizeEnable=0;SwapEffectUpgradeEnable=0;HwSchMode=2;" /f

echo.
echo Optimizations complete. It is recommended to restart your system.
echo.
echo NOTICE: Some changes may require a restart to be properly applied.
echo.
echo NOTE: For process priority in games, use Task Manager.
echo       Press CTRL+SHIFT+ESC during the game, right-click on the game process,
echo       Set priority -> High
echo.
pause