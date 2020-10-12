@echo off

SET ProjDir=%cd%
IF NOT EXIST setup.py (
    ECHO Please go to project folder!
    EXIT /B 1
)
echo Project Folder: %ProjDir%

REM Need to make sure the test coverage is only for src, not for both src and test
REM --omit -> exclude test code from coverage counts
REM conda run clears screen all the time, so we leave it out, but in the workflow.
REM dep_setup.py is not counted since we start with test side. So if we miss any
REM class, we won't know.
CALL coverage run --source=src --omit test/* -m unittest discover -s test
if errorlevel 1 exit /B 1

CALL coverage report --omit test/*
if errorlevel 1 exit /B 1

del /s coverage.svg
CALL coverage-badge -o coverage.svg
cd %WorkDir%
