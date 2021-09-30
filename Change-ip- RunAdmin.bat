@ECHO off
set PERIFERIC=Wi-Fi

set IP1=192.168.1.53
set SUBNET1=255.255.255.0
set GATEWAY1=192.168.1.1
set DNS1=8.8.8.8

set IP2=192.168.178.53
set SUBNET2=255.255.255.0
set GATEWAY2=192.168.178.1
set DNS2=8.8.8.8

set IP3=192.168.0.53
set SUBNET3=255.255.255.0
set GATEWAY3=192.168.0.1
set DNS3=8.8.8.8

set IP4=192.168.2.53
set SUBNET4=255.255.255.0
set GATEWAY4=192.168.2.1
set DNS4=8.8.8.8

cls
:start
ECHO.
ECHO 1. Change Connection1 Static IP %IP1% 
ECHO 2. Change Connection2 Static IP %IP2% 
ECHO 3. Change Connection3 Static IP %IP3% 
ECHO 4. Change Connection3 Static IP %IP4% 
ECHO 5. Obtain an IP address automatically
ECHO 6. Exit
set choice=
set /p choice=Type the number to print text.
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto con1
if '%choice%'=='2' goto con2
if '%choice%'=='3' goto con3
if '%choice%'=='4' goto con4
if '%choice%'=='5' goto autosearch
if '%choice%'=='6' goto end
ECHO "%choice%" is not valid, try again
ECHO.
goto start
:con1
ECHO Connecting Connection 1
netsh interface ip set address "%PERIFERIC%" static %IP1% %SUBNET1% %GATEWAY1% 1
netsh interface ipv4 set dns name="%PERIFERIC%" static %GATEWAY1%
netsh interface ip add dns name="%PERIFERIC%" addr=%DNS1% index=2
netsh int ip show config
goto end

:con2
ECHO Connecting Connection 2
netsh interface ip set address "%PERIFERIC%" static %IP2% %SUBNET2% %GATEWAY2% 1
netsh interface ipv4 set dns name="%PERIFERIC%" static %GATEWAY2%
netsh interface ip add dns name="%PERIFERIC%" addr=%DNS2% index=2
netsh int ip show config
goto end

:con3
ECHO Connecting Connection 3
netsh interface ip set address "%PERIFERIC%" static %IP3% %SUBNET3% %GATEWAY3% 1
netsh interface ipv4 set dns name="%PERIFERIC%" static %GATEWAY3%
netsh interface ip add dns name="%PERIFERIC%" addr=%DNS3% index=2
netsh int ip show config
goto end

:con4
ECHO Connecting Connection 4
netsh interface ip set address "%PERIFERIC%" static %IP4% %SUBNET4% %GATEWAY4% 1
netsh interface ipv4 set dns name="%PERIFERIC%" static %GATEWAY4%
netsh interface ip add dns name="%PERIFERIC%" addr=%DNS4% index=2
netsh int ip show config
goto end

:autosearch
ECHO obtaining auto IP
ipconfig /renew "%PERIFERIC%"
goto end

:bye
ECHO BYE
goto end


:end
pause