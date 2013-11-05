@echo off
setlocal
echo.


rem ************ CONTROL VARIABLES

set EXDIR=%~dp0
set TEMPDIR=%exdir%intermediaries

set DEFAULT_CRF=%EXDIR%Trained CRFs\WireGate.tcrf
set DEFAULT_LABELS=%EXDIR%Trained CRFs\WireGateLabels.txt

rem ************ ERROR CHECK

rem *** FIRST PARAM
if "x%1"=="x" goto paramError

if not exist %1 (
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

if not exist %crf% (
	echo ERROR: Could not find file: %crf%
	goto help
)
if not exist %labels% (
	echo ERROR: Could not find file: %labels%
	goto help
)
goto main

rem ************ MAIN

:main
COPY "%~f1" "%TEMPDIR%\%~nx1"
set xml=%TEMPDIR%\%~n1
goto label


:label
echo Labeling strokes...
"%EXDIR%RunCRF\RunCRF.exe" -c "%crf%" -l "%labels%" -o "%xml%.labeled.xml" "%xml%.xml"
set xml=%xml%.labeled
goto displayLabels


:displayLabels
echo Showing labels...
"%EXDIR%OldLabeler\Labeler.exe" "%xml%.xml"
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
echo   LabelAndGroupXML targetFile [crfFile]
echo     targetFile - a an MIT XML sketch file
echo     crfFile    - a specific, trained conditional random field (*.tcrf) to be
echo                  used during recognition (optional)
goto end

:success
echo Completed.

:end