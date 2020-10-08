SET WorkDir=%cd%
SET BatchDir=%~dp0
SET ProjDir= %BatchDir%..

echo Project Folder: %ProjDir%

REM git config --global credential.github.com.useHttpPath true
REM windows
REM git config --global credential.helper wincred
REM *nix
REM git config --global credential.helper store
git status

FOR /F %%I IN ('python -c "import dep_setup;print(dep_setup.app_version)"') DO SET app_version=%%I
echo app version: %app_version%

git tag -a %app_version% -m "release: tag version %app_version%"

git pull
git push --tags

REM bump_version1 keeps single digit on minor and patch, xx.x.x
FOR /F %%I IN ('python -c "import pypigeonhole_build.file_edit_utils as fu; print(fu.bump_version1(""%app_version%"", ""dep_setup.py""))"') DO SET new_version=%%I
echo new version: %new_version%

git add dep_setup.py
git commit -m "release: bump version %app_version% up to %new_version%"

git pull
git push

cd %WorkDir%
