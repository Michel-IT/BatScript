@echo off
:: COMMENT
:: © 2012 https://github.com/Michel-IT. All rights reserved.
:: You can use this file and disclose it. 
:: Please do not remove this comment. 
:: Out of respect for intellectual property.

SET IP=192.168.178.2
SET USER=admin
SET PASS=password1234

cd ../Utility/
for /f "tokens=* delims=" %%# in ('base64.bat -encode %PASS%') do set "PASSencoded=%%#"
::echo %PASSencoded% 

curl "http://%IP%/login/Auth" -H "Cookie: user=%USER%" -H "Origin: http://%IP%" -H "Referer: http://%IP%/login.html" --data-raw "username=%USER%&password=%PASSencoded%&country=US&timeZone=7&time=" --insecure
curl "http://%IP%/goform/setSysReboot" -H "Cookie: user=%USER%" -H "Origin: http://%IP%" -H "Referer: http://%IP%/system_config.html" --data-raw "action=reboot" --insecure
