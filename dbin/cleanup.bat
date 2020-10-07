SET BatchDir=%~dp0
SET ProjDir=%BatchDir%..

echo Project Folder: %ProjDir%

RMDIR /Q /S %ProjDir%\build
if exist %ProjDir%\build EXIT /B 1

RMDIR /Q /S %ProjDir%\dist
if exist %ProjDir%\dist EXIT /B 1

RMDIR /Q /S %ProjDir%\__pycache__
if exist %ProjDir%\__pycache__ EXIT /B 1

FOR /d %%G IN ("%ProjDir%\*.egg-info") DO RMDIR /Q /S "%%~G"

REM come from pip install -e .
FOR /d %%G IN ("%ProjDir%\src\*.egg-info") DO RMDIR /Q /S "%%~G"

EXIT /B 0
