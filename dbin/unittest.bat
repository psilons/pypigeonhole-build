SET ProjDir=%cd%
IF NOT EXIST setup.py (
    ECHO Please go to project folder!
    EXIT /B 1
)
echo Project Folder: %ProjDir%

REM Need to make sure the test coverage is only for src, not for both src and test
REM --omit -> exclude test coverage counts
CALL conda run coverage run --omit test/* -m unittest discover -s test
CALL conda run coverage report --omit test/*

del /s coverage.svg
CALL conda run coverage-badge -o coverage.svg
cd %WorkDir%
