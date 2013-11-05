@echo off
setlocal
echo.


rem ************ CONTROL VARIABLES

set EXDIR=%~dp0
set TEMPDIR=%exdir%intermediaries

set DEFAULT_CRF=%EXDIR%Trained CRFs\WireGate.tcrf
set DEFAULT_LABELS=%EXDIR%Trained CRFs\WireGateLabels.txt
set DEFAULT_DOMAIN=%EXDIR%OldLabeler\DefaultDomain.txt

rem ************ ERROR CHECK

rem *** FIRST PARAM
if "x%~f1"=="x" goto paramError

if not exist "%~f1" (
       echo ERROR: Could not find file: %1
       goto help
)

rem *** SECOND PARAM
set crf=%DEFAULT_CRF%
set labels=%DEFAULT_LABELS%

if "x%2"=="x" goto main
echo Using custom CRF: %2. Assuming label file is %~n2Labels.txt
set crf="%~f2"
set labels="%~dpn2Labels.txt"

if not exist "%crf%" (
	echo ERROR: Could not find file: %crf%
	goto help
)
if not exist "%labels%" (
	echo ERROR: Could not find file: %labels%
	goto help
)
goto main

rem ************ MAIN

:main
set xml=%TEMPDIR%\%~n1
goto infer

:convert
echo Converting %~nx1 to MIT XML...
rem %EXDIR%JntToXml\JntToXml.exe "%~f1" -f
set xml=%TEMPDIR%\%~n1
goto label

:label
echo Labeling strokes...
"%EXDIR%RunCRF\RunCRF.exe" -c "%crf%" -l "%labels%" -o "%xml%.labeled.xml" "%xml%.xml"
set xml=%xml%.labeled
goto displayLabels

:infer
echo Converting to MIT XML and labeling strokes...
DEL /Q "%TEMPDIR%\inferred\*.*"
COPY "%~f1" "%TEMPDIR%\inferred\%~nx1"
"%EXDIR%InferFromJnt (Command Line)\InferFromJnt.exe" -crf "%crf%" "%labels%" -d "%TEMPDIR%\inferred"

MOVE "%TEMPDIR%\inferred\*.*" "%TEMPDIR%"
MOVE "%CD%\inferredJnt\%~n1.autolabeled.xml" "%TEMPDIR%"
RMDIR /S /Q "%CD%\inferredJnt"
set xml=%TEMPDIR%\%~n1.autolabeled


:displayLabels
echo Showing labels...
START "windowtitle" "%EXDIR%OldLabeler\Labeler.exe" "%xml%.xml" "%DEFAULT_DOMAIN%
goto group

:group
echo Grouping...
"%EXDIR%Grouper\Grouper.exe" "%xml%.xml"
set xml=%xml%.grp
goto displayGroups

:displayGroups
echo Showing groups...
START "windowtitle" "%EXDIR%OldLabeler\Labeler.exe" "%xml%.xml"

goto success


rem ************** ROUTINES

:paramError
echo ERROR: Incorrect number of parameters.
echo.
goto help

:help
echo USAGE
echo   ProcessJNT targetFile [crfFile]
echo     targetFile - a Windows Journal sketch file (*.jnt) that you want to
echo                  process.
echo     crfFile    - a specific, trained conditional random field (*.tcrf) to be
echo                  used during recognition (optional)
goto end

:success
echo Completed.

:end