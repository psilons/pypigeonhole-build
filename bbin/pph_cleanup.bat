@echo off
SET ProjDir=%cd%
IF NOT EXIST setup.py (
    ECHO Please go to project folder!
    EXIT /B 1
)
echo Cleanup Project Folder: %ProjDir%

if exist %ProjDir%\build RMDIR /S /Q %ProjDir%\build
if exist %ProjDir%\build EXIT /B 1

if exist %ProjDir%\dist RMDIR /S /Q %ProjDir%\dist
if exist %ProjDir%\dist EXIT /B 1

if exist %ProjDir%\dist_conda RMDIR /S /Q %ProjDir%\dist_conda
if exist %ProjDir%\dist_conda EXIT /B 1

if exist %ProjDir%\dist_zip RMDIR /S /Q %ProjDir%\dist_zip
if exist %ProjDir%\dist_zip EXIT /B 1

FOR /d %%G IN ("%ProjDir%\*.egg-info") DO RMDIR /S /Q "%%~G"

REM come from pip install -e .
FOR /d %%G IN ("%ProjDir%\src\*.egg-info") DO RMDIR /S /Q "%%~G"

REM if we miss these 2, that's fine.
echo Done
