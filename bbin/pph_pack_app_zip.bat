SET ProjDir=%cd%
IF NOT EXIST setup.py (
    ECHO Please go to project folder!
    EXIT /B 1
)
echo Project Folder: %ProjDir%

for %%a in ("%ProjDir%") do set "proj_name=%%~nxa"
echo %proj_name%

cd %ProjDir%
IF EXIST %ProjDir%\dist_bin (
    RMDIR /Q /S %ProjDir%\dist_zip
)
mkdir %ProjDir%\dist_zip

REM *nix and windows 10 has tar command. tar + zip is best.
REM assume custom build puts artifacts/executables in dist
tar -czf %ProjDir%\dist_zip\%proj_name%.tar.gz bin conf dist
if errorlevel 1 exit /B 1

echo "Done."