@echo off
cd ../Utility/
for /f "tokens=* delims=" %%# in ('base64.bat -decode RnJhZ29sYTg4') do set "decoded=%%#"
echo %decoded% 

for /f "tokens=* delims=" %%# in ('base64.bat -encode Fragola88') do set "encoded=%%#"
echo %encoded% 
