@echo off
setlocal enabledelayedexpansion

:: === SETTINGS ===
set "DATABASE_NAME=alhyan"
set "USER=postgres"
set "BACKUP_DIR=C:\backups"
set "EXTERNAL_SSD_DRIVE=D:"
set "EXTERNAL2=F:"
set "EXTERNAL3=G:"
set "PGPASSFILE=C:\Users\Public\pgpass.conf"
set "PG_DUMP_PATH=C:\Program Files\PostgreSQL\16\bin\pg_dump.exe"

:: === TIMESTAMP (YYYYMMDD_HHMMSS) ===
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set "ldt=%%I"
set "TIMESTAMP=!ldt:~0,8!_!ldt:~8,6!"

:: === BACKUP FILE ===
set "BACKUP_FILE=%BACKUP_DIR%\backup_!TIMESTAMP!.sql"

:: === START BACKUP ===
echo.
echo [INFO] Starting backup for database "%DATABASE_NAME%" at !TIMESTAMP!...
set PGPASSFILE=C:\Users\Public\pgpass.conf
if not exist "%BACKUP_DIR%" (
    echo [INFO] Creating backup directory: "%BACKUP_DIR%"
    mkdir "%BACKUP_DIR%"
)

if not exist "%PG_DUMP_PATH%" (
    echo [ERROR] pg_dump not found at "%PG_DUMP_PATH%". Please check the path.
    exit /b 1
)

:: Perform the backup
"%PG_DUMP_PATH%" -h localhost -U %USER% -b -v -f "%BACKUP_FILE%" %DATABASE_NAME%
if errorlevel 1 (
    echo [ERROR] Backup failed!
    exit /b 1
)

echo [INFO] Backup completed successfully.
echo [INFO] Backup file: "%BACKUP_FILE%"

:: === COPY TO EXTERNAL DRIVES ===
echo.
echo [INFO] Copying backup to external drives...

for %%D in ("%EXTERNAL_SSD_DRIVE%" "%EXTERNAL2%" "%EXTERNAL3%") do (
    if exist %%D\ (
        echo [INFO] Copying to %%D...
        copy "%BACKUP_FILE%" %%D\
    ) else (
        echo [WARN] Drive %%D not found — skipping.
    )
)

echo.
echo [SUCCESS] Backup and copy operations completed.
endlocal
pause
