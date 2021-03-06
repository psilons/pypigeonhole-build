@echo off

SET ProjDir=%cd%
IF NOT EXIST setup.py (
    ECHO Please go to project folder!
    EXIT /B 1
)
echo Project Folder: %ProjDir%

SET curr_env=%CONDA_DEFAULT_ENV%
ECHO current env: %curr_env%
IF "%curr_env%" == "" (
    echo Please activate conda env first!
    EXIT /B 1
)

REM Need to make sure the test coverage is only for src, not for both src and test
REM --omit -> exclude test code from coverage counts
REM conda run clears screen all the time, so we leave it out, but in the workflow.
CALL coverage run --source=src --omit test/* -m unittest discover -s test
if errorlevel 1 exit /B 1

CALL coverage report --omit test/*
if errorlevel 1 exit /B 1

del /s coverage.svg
CALL coverage-badge -o coverage.svg
if errorlevel 1 exit /B 1

echo Done
