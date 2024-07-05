@echo off
setlocal

REM R Skript ausfuehren und Fehler in error.log speichern
"C:\Program Files\R\bin\Rscript.exe" "D:\radolan_data_pr\main.R" "ftp://opendata.dwd.de/climate_environment/CDC/" 2024 1 "D:/radolan_data_pr" 6 2> "D:\radolan_data_pr\error.log"

endlocal
exit /b

