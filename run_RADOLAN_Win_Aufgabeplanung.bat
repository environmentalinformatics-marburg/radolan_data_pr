@echo off
setlocal

REM Argumente aus der Aufgabenplanung entgegennehmen
set "base_url=%1"
set "year=%2"
set "month=%3"
set "output_dir=%4"
set "some_value=%5"

REM Pfad zu Rscript.exe
set "rscript_path=C:\Program Files\R\bin\Rscript.exe"

REM R Skript ausfuehren und Fehler in error.log speichern
"%rscript_path%" "D:\radolan\main.R" "%base_url%" %year% %month% "%output_dir%" %some_value% 2> "%output_dir%\error.log"

endlocal
exit /b

