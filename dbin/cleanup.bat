SET BatchDir=%~dp0
SET ProjDir=%BatchDir%..

echo Project Folder: %ProjDir%

RMDIR /Q /S %ProjDir%\build

RMDIR /Q /S %ProjDir%\dist

FOR /d %%G IN ("%ProjDir%\*.egg-info") DO RMDIR /Q /S "%%~G"

REM come from pip install -e .
FOR /d %%G IN ("%ProjDir%\src\*.egg-info") DO RMDIR /Q /S "%%~G"
