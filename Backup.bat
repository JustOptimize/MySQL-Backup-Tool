@echo off
setlocal EnableDelayedExpansion

For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a-%%b)


for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set dt=%%a
set year=%dt:~0,4%
set month=%dt:~4,2%
set day=%dt:~6,2%

if %month%==01 set monthname=Gen
if %month%==02 set monthname=Feb
if %month%==03 set monthname=Mar
if %month%==04 set monthname=Apr
if %month%==05 set monthname=Mag
if %month%==06 set monthname=Giu
if %month%==07 set monthname=Lug
if %month%==08 set monthname=Ago
if %month%==09 set monthname=Set
if %month%==10 set monthname=Ott
if %month%==11 set monthname=Nov
if %month%==12 set monthname=Dic

SET backupdir="C:\Users\Samuele\Desktop\backupsql\%year%\%monthName%\%day%"
SET mysqluername=root
SET mysqlpassword=somepassword
SET database=lvirp

IF NOT EXIST "%backupdir%" mkdir %backupdir%

C:\xampp\mysql\bin\mysqldump.exe -u %mysqluername% %database% >  %backupdir%\%mytime%.sql

::-p PASSWORD