REM package both lib and app, driven by bld.bat
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
)

if exist %ProjDir%\dist_conda RMDIR /Q /S %ProjDir%\dist_conda

conda-build bbin\pkg_conda_cfg --output-folder dist_conda
if errorlevel 1 exit /B 1

conda build purge

echo Done, check result in dist_conda
