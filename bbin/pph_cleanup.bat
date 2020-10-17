SET ProjDir=%cd%
IF NOT EXIST setup.py (
    ECHO Please go to project folder!
    EXIT /B 1
)
echo Project Folder: %ProjDir%

if exist %ProjDir%\build RMDIR /Q /S %ProjDir%\build
if exist %ProjDir%\build EXIT /B 1

if exist %ProjDir%\dist RMDIR /Q /S %ProjDir%\dist
if exist %ProjDir%\dist EXIT /B 1

if exist %ProjDir%\dist_conda RMDIR /Q /S %ProjDir%\dist_conda
if exist %ProjDir%\dist_conda EXIT /B 1

if exist %ProjDir%\dist_zip RMDIR /Q /S %ProjDir%\dist_conda
if exist %ProjDir%\dist_zip EXIT /B 1

FOR /d %%G IN ("%ProjDir%\*.egg-info") DO RMDIR /Q /S "%%~G"

REM come from pip install -e .
FOR /d %%G IN ("%ProjDir%\src\*.egg-info") DO RMDIR /Q /S "%%~G"

REM if we miss these 2, that's fine.
echo "Done"
