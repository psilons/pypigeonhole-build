echo %cd%

ls -ltr
ls -ltr %SRC_DIR%
ls -ltr %PREFIX%
ls -ltr "%SCRIPTS%"
REM Or use %PREFIX%\Scripts

REM Windows use <env> and <env>\Scripts folders, Linux uses <env> and <env>/bin
REM So copying to either folder is working. To erase the difference between OS,
REM use <env>, uniform across platform
echo copying scripts to %PREFIX%...
REM xcopy %SRC_DIR%\dbin "%SCRIPTS%"
REM xcopy %SRC_DIR%\bbin "%SCRIPTS%"

REM Do not add subfolder after %PREFIX%, otherwise the build will fail.
REM mkdir %PREFIX%\bin
copy %SRC_DIR%\dbin\pph* %PREFIX%
copy %SRC_DIR%\bbin\pph* %PREFIX%
REM copying break this again, so reset them here again
dos2unix %PREFIX%\pph*
REM this is still not working! copying alternates this!
REM icacls %PREFIX%\pph* /grant Everyone:RX

REM cp %SRC_DIR%\bbin\pkg_conda_cfg\post-link.sh %PREFIX%\bin

%PYTHON% -m pip install . --ignore-installed -vv
