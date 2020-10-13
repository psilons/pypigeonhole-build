@echo off

SET ProjDir=%cd%
IF NOT EXIST setup.py (
    ECHO Please go to project folder!
    EXIT /B 1
)
echo Project Folder: %ProjDir%

for %%a in ("%ProjDir%") do set "proj_name=%%~nxa"
echo project name: %proj_name%
set pkg=%proj_name:-=_%
echo top package name: %pkg%

IF NOT EXIST src\%pkg%\dep_setup.py (
    ECHO Please create dep_setup.py in project src folder first!
    EXIT /B 1
)

set PYTHONPATH=src;%PYTHONPATH%

echo create conda environment.yaml
python src\%pkg%\dep_setup.py conda
if errorlevel 1 exit /B 1
REM environment.yaml should be created for conda installation

echo create pip requirements.txt
REM we need to generate requirements.txt as well since github needs for dependency graph
python src\%pkg%\dep_setup.py pip
if errorlevel 1 exit /B 1

FOR /F %%I IN ('python src\%pkg%\dep_setup.py conda_env') DO SET new_env=%%I
if errorlevel 1 exit /B 1
echo new env: %new_env%

CALL conda info --envs

SET curr_env=%CONDA_DEFAULT_ENV%
ECHO current env: %curr_env%
IF "%curr_env%" NEQ "" (
    CALL conda deactivate
    if errorlevel 1 exit /B 1
    echo current env after deactivate: %CONDA_DEFAULT_ENV%
)

REM we have to CALL in the front, otherwise conda stop the whole batch.
CALL conda env create -f environment.yaml

if errorlevel 1 (
    ECHO env[%new_env%] exists, removing it ...
    CALL conda env remove -n %new_env%
    if errorlevel 1 exit /B 1

    CALL conda env create -f environment.yaml
    if errorlevel 1 exit /B 1
)

CALL conda activate %new_env%
if errorlevel 1 exit /B 1
echo current conda env: %CONDA_DEFAULT_ENV%

REM print dependency tree
pipdeptree

echo --
echo run "conda activate %new_env%" to activate environment
echo --
echo run "conda info --envs" to check current activated environment

CALL conda deactivate
