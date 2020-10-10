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

REM we have to CALL in the front, otherwise conda stop the whole batch.
CALL conda env create -f environment.yaml

if errorlevel 1 (
    ECHO env[%new_env%] exists, removing it ...
    GOTO retry1
)

CALL conda activate %new_env%
if errorlevel 1 exit /B 1

REM print dependency tree
pipdeptree

EXIT /B 0

:retry1
REM check whether we are in the env that we want to delete
SET curr_env=%CONDA_DEFAULT_ENV%
ECHO current env: %curr_env%

IF "%curr_env%" == "" (
    GOTO retry2
)

IF "%curr_env%" == "%new_env%" (
    REM if we are in this env now, get out first
    CALL conda deactivate
)


:retry2
CALL conda env remove -n %new_env%
if errorlevel 1 exit /B 1

REM update is not good enough because of pip install, so remove all.
CALL conda env create -f environment.yaml
if errorlevel 1 exit /B 1

CALL conda activate %new_env%

REM print dependency tree, it's taking some time
pipdeptree
