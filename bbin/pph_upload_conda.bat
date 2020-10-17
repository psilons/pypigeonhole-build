REM No need to use this script:
REM     the artifact name and path are not predictable
REM     anaconda login is not re-entrant: if I am in, leave me alone.
REM In contrast, PIP is better.
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

REM This is not working yet
if "%~1"=="" (
    echo Please pass in artifact path/name.tar.bz2
    exit /B 1
)
SET pkg=%1
REM conda convert --platform all %pkg% -o conda_output/

REM anaconda login

anaconda upload %pkg%
