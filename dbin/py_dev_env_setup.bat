SET ProjDir=%cd%
IF NOT EXIST setup.py (
    ECHO Please go to project folder!
    EXIT /B 1
)
echo Project Folder: %ProjDir%

IF NOT EXIST src\dep_setup.py (
    ECHO Please create dep_setup.py in project src folder first!
    EXIT /B 1
)

python src\dep_setup.py conda
REM environment.yaml should be created for conda installation

REM we need to generate requirements.txt as well since github needs for dependency graph
python src\dep_setup.py pip

FOR /F %%I IN ('python src\dep_setup.py conda_env') DO SET new_env=%%I
echo new env: %new_env%

REM we have to CALL in the front, otherwise conda stop the whole batch.
CALL conda env create -f environment.yaml

SET cerr=%ERRORLEVEL%
ECHO create return code: %cerr%
if "%cerr%" == "1" (
    GOTO retry1
)

CALL conda activate %new_env%

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

REM update is not good enough because of pip install, so remove all.
CALL conda env create -f environment.yaml

CALL conda activate %new_env%

REM print dependency tree, it's taking some time
pipdeptree
