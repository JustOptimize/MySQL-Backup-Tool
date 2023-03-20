@echo off

:: Enable delayed expansion (for the forfiles command)
setlocal EnableExtensions EnableDelayedExpansion

:: SETTINGS
set "backup_dir=C:\BackupsSQL"
set "mysql_username=root"
set "mysql_password="
set "database=dbtest"
set "delete_old_files=true"
set "delete_how_old_files=15"
set "mysql_dir=C:\xampp\mysql\bin\mysqldump.exe"
:: DO NOT EDIT BELOW THIS LINE


:: Get the current time
for /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (
  set "mytime=%%a-%%b"
)

:: Get the current date
for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set dt=%%a
set year=%dt:~0,4%
set month=%dt:~4,2%
set day=%dt:~6,2%

:: Get the month name
set "monthname="
if "%month%"=="01" set "monthname=Jan"
if "%month%"=="02" set "monthname=Febr"
if "%month%"=="03" set "monthname=Mar"
if "%month%"=="04" set "monthname=Apr"
if "%month%"=="05" set "monthname=May"
if "%month%"=="06" set "monthname=Jun"
if "%month%"=="07" set "monthname=Jul"
if "%month%"=="08" set "monthname=Aug"
if "%month%"=="09" set "monthname=Sept"
if "%month%"=="10" set "monthname=Oct"
if "%month%"=="11" set "monthname=Nov"
if "%month%"=="12" set "monthname=Dec"

:: Create the backup folder C:\BackupsSQL\1 January 2014
set "backupFolder=%backup_dir%\%day% %monthname% %year%\"
if not exist "%backupFolder%" (
  mkdir "%backupFolder%"
)

:: Create the backup file
set "backupFile=%backupFolder%%mytime%.sql"
if defined mysql_password (
  "%mysql_dir%" -u "%mysql_username%" -p"%mysql_password%" "%database%" > "%backupFile%"
) else (
  "%mysql_dir%" -u "%mysql_username%" "%database%" > "%backupFile%"
)

:: Delete old files
if "%delete_old_files%"=="true" (
  echo Deleting files older than %delete_how_old_files% days for %backup_dir%
  forfiles -p %backup_dir% -s -m *.* -d -%delete_how_old_files% -c "cmd /c del @path"

  echo Deleting empty folders
  for /f "usebackq delims=" %%d in (`"dir %backup_dir% /ad/b/s"`) do rd "%%d"
)
