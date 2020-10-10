SET ProjDir=%cd%
IF NOT EXIST setup.py (
    ECHO Please go to project folder!
    EXIT /B 1
)
echo Project Folder: %ProjDir%

for %%a in ("%ProjDir%") do set "proj_name=%%~nxa"
echo %proj_name%

cd %ProjDir%
IF EXIST %ProjDir%\dist (
    RMDIR /Q /S %ProjDir%\dist
)
mkdir %ProjDir%\dist

REM *nix and windows 10 has tar command. take one of src/output
tar -czf %ProjDir%\dist\%proj_name%.tar.gz bin conf src

cd %WorkDir%
