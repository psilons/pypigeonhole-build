SET WorkDir=%cd%
SET BatchDir=%~dp0

cd %BatchDir%..
REM Need to make sure the test coverage is only for src, not for both src and test
REM --omit -> exclude test coverage counts
CALL conda run coverage run --omit test/* -m unittest discover -s test
CALL conda run coverage report --omit test/*

del /s coverage.svg
CALL conda run coverage-badge -o coverage.svg
cd %WorkDir%
