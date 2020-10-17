REM package both lib and app, driven by bld.bat
@echo off
SET ProjDir=%cd%
IF NOT EXIST setup.py (
    ECHO Please go to project folder!
    EXIT /B 1
)
echo Project Folder: %ProjDir%

if exist %ProjDir%\dist_conda RMDIR /Q /S %ProjDir%\dist_conda

conda-build bbin\pkg_conda_cfg --output-folder dist_conda

conda build purge
