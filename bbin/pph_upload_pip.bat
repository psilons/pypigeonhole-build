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

SET repo=%1
if "%repo%" == "" (
    SET repo=%PIP_UPLOAD_REPO%
    if "%repo%" == "" (
        SET repo=pypi
    )
)

REM make sure the repository is defined in ~/.pypirc.
ECHO use PIP repository: %repo%

SET conf_file=%PYPI_CONF_FILE%
if "%conf_file%" == "" (
    SET conf_file=%USERPROFILE%\.pypirc
)

twine upload -r %repo% --config-file %conf_file% %ProjDir%/dist/*
