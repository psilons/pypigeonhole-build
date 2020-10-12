#!/bin/bash

export PROJ_DIR=$(pwd)
if [ ! -f "setup.py"]; then
    echo "Please go to project folder!"
    exit 1
fi
echo $PROJ_DIR

if [ ! -f "src/dep_setup.py"]; then
    echo "Please create dep_setup.py in project src first!"
    exit 1
fi

REM To setup user/pswd for command line
REM git config --global credential.github.com.useHttpPath true
REM windows
REM git config --global credential.helper wincred
REM *nix
REM git config --global credential.helper store
git status

FOR /F %%I IN ('python src\dep_setup.py app_env') DO SET app_version=%%I
echo app version: %app_version%

git tag -a %app_version% -m "release: tag version %app_version%"

git pull
git push --tags

REM bump_version1 keeps single digit on minor and patch, xx.x.x
FOR /F %%I IN ('python -c "import pypigeonhole_build.app_version_control as fu; print(fu.bump_version1(""%app_version%"", ""src\dep_setup.py""))"') DO SET new_version=%%I
echo new version: %new_version%

git add src\dep_setup.py
git commit -m "release: bump version %app_version% up to %new_version%"

git pull
git push

