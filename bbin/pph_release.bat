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

for %%a in ("%ProjDir%") do set "proj_name=%%~nxa"
echo project name: %proj_name%
set pkg=%proj_name:-=_%
echo top package name: %pkg%

IF NOT EXIST src\%pkg%\app_setup.py (
    ECHO Please create app_setup.py in project src folder first!
    EXIT /B 1
)

REM To setup user/pswd for command line
REM git config --global credential.github.com.useHttpPath true
REM windows
REM git config --global credential.helper wincred
REM *nix
REM git config --global credential.helper store
git status

FOR /F %%I IN ('python setup.py --version') DO SET app_version=%%I
echo app version: %app_version%
if errorlevel 1 exit /B 1

git tag -a %app_version% -m "release: tag version %app_version%"

git pull
git push --tags
if errorlevel 1 exit /B 1

echo ------------------------------------------------------------------------------
set PYTHONPATH=src;%PYTHONPATH%
REM bump_version1 keeps single digit on minor and patch, xx.x.x
FOR /F %%I IN ('python -c "import pypigeonhole_build.app_version_control as fu; import %pkg%.app_setup; print(fu.bump_version(""%app_version%"", ""src/%pkg%/app_setup.py""))"') DO SET new_version=%%I
if errorlevel 1 (
    exit /B 1
)
echo new version: %new_version%

git add src\%pkg%\app_setup.py
git commit -m "release: bump version %app_version% up to %new_version%"

git pull
git push
if errorlevel 1 exit /B 1

echo Done, check new version in src/%pkg%/app_setup.py
