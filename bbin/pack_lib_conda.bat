@echo off
SET ProjDir=%cd%
IF NOT EXIST setup.py (
    ECHO Please go to project folder!
    EXIT /B 1
)
echo Project Folder: %ProjDir%

conda-build bbin\pkg_conda_cfg --output-folder dist_conda

REM test with:
REM conda install --use-local pypigeonhole-build
REM conda remove pypigeonhole-build
