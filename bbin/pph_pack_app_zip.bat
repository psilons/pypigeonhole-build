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
    RMDIR /Q /S %ProjDir%\dist_bin
)
mkdir %ProjDir%\dist_bin

REM *nix and windows 10 has tar command. tar + zip is best.
REM assume custom build put artifacts/executables in build_bin
tar -czf %ProjDir%\dist_bin\%proj_name%.tar.gz bin conf build_bin
