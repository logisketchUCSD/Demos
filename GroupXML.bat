@echo off
setlocal
echo.


rem ************ CONTROL VARIABLES

set EXDIR=%~dp0
set TEMPDIR=%exdir%intermediaries

rem ************ ERROR CHECK

rem *** FIRST PARAM
if "x%1"=="x" goto paramError

if not exist %1 (
       echo ERROR: Could not find file: %1
       goto help
)

goto main

rem ************ MAIN

:main
COPY "%~f1" "%TEMPDIR%\%~nx1"
set xml=%TEMPDIR%\%~n1
goto group

:group
echo Grouping...
"%EXDIR%Grouper\Grouper.exe" "%xml%.xml"
set xml=%xml%.grp
goto displayGroups

:displayGroups
echo Showing groups...
"%EXDIR%OldLabeler\Labeler.exe" "%xml%.xml"

goto success


rem ************** ROUTINES

:paramError
echo ERROR: Incorrect number of parameters.
echo.
goto help

:help
echo USAGE
echo   GroupXML targetFile
echo     targetFile - an MIT XML file that you want to process.
goto end

:success
echo Completed.

:end