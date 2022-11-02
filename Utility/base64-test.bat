@echo off
:: COMMENT
:: © 2012 https://github.com/Michel-IT. All rights reserved.
:: You can use this file and disclose it. 
:: Please do not remove this comment. 
:: Out of respect for intellectual property.

cd ../Utility/

for /f "tokens=* delims=" %%# in ('base64.bat -decode RnJhZ29sYTg4') do set "decoded=%%#"
echo %decoded% 

for /f "tokens=* delims=" %%# in ('base64.bat -encode Fragola88') do set "encoded=%%#"
echo %encoded% 
