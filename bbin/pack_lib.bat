SET WorkDir=%cd%
SET BatchDir=%~dp0
SET ProjDir=%BatchDir%..

echo Project Folder: %ProjDir%

call %BatchDir%cleanup.bat
if %errorlevel% neq 0 EXIT /B %errorlevel%

cd %ProjDir%
set PYTHONPATH=src;%PYTHONPATH
REM Other options are bdist, bdist_egg
REM # wheel with -none-any.whl means pure python and any platform
python setup.py bdist_wheel sdist
REM artifacts are in dist folder here.

REM Move this out of source folder.
REM We don't want to delete it in case we need to inspect it.
FOR /d %%G IN ("%ProjDir%\src\*.egg-info") DO MOVE "%%~G" %ProjDir%

cd %WorkDir%

