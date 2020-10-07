SET WorkDir=%cd%
SET BatchDir=%~dp0
SET ProjDir= %BatchDir%..

call %BatchDir%cleanup.bat

cd %ProjDir%
REM Other options are bdist, bdist_egg
REM # wheel with -none-any.whl means pure python and any platform
python setup.py bdist_wheel sdist
REM artifacts are in dist folder here.

REM Move this out of source folder.
REM We don't want to delete it in case we need to inspect it.
FOR /d %%G IN ("%ProjDir%\src\*.egg-info") DO MV "%%~G" %ProjDir%

cd %WorkDir%

