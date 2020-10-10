@echo off
SET BatchDir=%~dp0

SET ProjDir=%cd%
IF NOT EXIST setup.py (
    ECHO Please go to project folder!
    EXIT /B 1
)
echo Project Folder: %ProjDir%

call %BatchDir%cleanup.bat
if errorlevel 1 exit /B 1

REM Other options are bdist, bdist_egg
REM wheel with -none-any.whl means pure python and any platform
python setup.py bdist_wheel sdist
REM artifacts are in dist folder here.

REM Move this out of source folder.
REM We don't want to delete it in case we need to inspect it.
REM FOR /d %%G IN ("%ProjDir%\src\*.egg-info") DO MOVE "%%~G" %ProjDir%
REM Don't do this, it interferes with conda packing. Leave it there.
