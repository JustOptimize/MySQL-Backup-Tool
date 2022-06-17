@echo off

::SETTINGS

SET backupdir="C:\BackupsSQL"

SET mysqluername=root
SET mysqlpassword=
SET database=dbtest

SET deleteOldFiles=true
SET deleteHowOldFiles=15

SET mysqldir=C:\xampp\mysql\bin\mysqldump.exe
::

setlocal EnableDelayedExpansion

for /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a-%%b)

for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set dt=%%a
set year=%dt:~0,4%
set month=%dt:~4,2%
set day=%dt:~6,2%

if %month%==01 set monthname=Jan
if %month%==02 set monthname=Feb
if %month%==03 set monthname=Mar
if %month%==04 set monthname=Apr
if %month%==05 set monthname=May
if %month%==06 set monthname=Jun
if %month%==07 set monthname=Jul
if %month%==08 set monthname=Aug
if %month%==09 set monthname=Sep
if %month%==10 set monthname=Oct
if %month%==11 set monthname=Nov
if %month%==12 set monthname=Dic

IF NOT EXIST "%backupdir%\(%month%) %day% %monthName% %year%" mkdir "%backupdir%\(%month%) %day% %monthName% %year%"

IF DEFINED mysqlpassword (
  %mysqldir% -u %mysqluername% -p %mysqlpassword% %database% >  "%backupdir%\(%month%) %day% %monthName% %year%\%mytime%.sql"
)ELSE (
  %mysqldir% -u %mysqluername% %database% >  "%backupdir%\(%month%) %day% %monthName% %year%\%mytime%.sql"
)

IF %deleteOldFiles%==true (

::Delete files
forfiles -p %backupdir% -s -m *.* -d -%deleteHowOldFiles% -c "cmd /c del @path"

::Delete Empty Folders
for /f "usebackq delims=" %%d in (`"dir %backupdir% /ad/b/s"`) do rd "%%d"

)


