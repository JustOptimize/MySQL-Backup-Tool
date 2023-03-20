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
for /f "tokens=1-2 delims==" %%a in (
'wmic OS Get localdatetime /value ^| find "="'
) do (
  if "%%a"=="Day" set "day=%%b"
  if "%%a"=="Month" set "month=%%b"
  if "%%a"=="Year" set "year=%%b"
)

:: Get the month name
set "monthname=Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
for /f "tokens=%month% delims= " %%a in ("%monthname%") do set "monthname=%%a"

:: Create the backup folder
set "backupFolder=%backup_dir%(%month%) %day% %monthname% %year%"
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
  forfiles /p "%backup_dir%" /s /m . /d -%delete_how_old_files% /c "cmd /c if @isdir==FALSE del @file"
  for /f "delims=" %%d in ('dir /ad /b /s "%backup_dir%" ^| sort /R') do rd "%%d"
)
