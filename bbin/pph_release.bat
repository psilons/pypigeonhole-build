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

REM To setup user/pswd for command line
REM git config --global credential.github.com.useHttpPath true
REM windows
REM git config --global credential.helper wincred
REM *nix
REM git config --global credential.helper store
git status

FOR /F %%I IN ('python setup.py --version') DO SET app_version=%%I
echo app version: %app_version%

git tag -a %app_version% -m "release: tag version %app_version%"

git pull
git push --tags

REM bump_version1 keeps single digit on minor and patch, xx.x.x
FOR /F %%I IN ('python -c "import %pkg%.app_version_control as fu; print(fu.bump_version1(""%app_version%"", ""src\%pkg%\dep_setup.py""))"') DO SET new_version=%%I
echo new version: %new_version%

git add src\pypigeonhole_build\dep_setup.py
git commit -m "release: bump version %app_version% up to %new_version%"

git pull
git push

