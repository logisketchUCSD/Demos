@echo off

******** PROCESS COMMAND-LINE

if "x%1"=="x" goto paramError

if not exist %1 (
       echo ERROR: Could not find file: %1
       goto end
)


******** MAIN
Labeler.exe "%~f1"


goto end

:paramError
echo ERROR: Incorrect number of parameters.
echo.
goto end

:end