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

xcopy %SRC_DIR%\dbin\*.bat %PREFIX%\Scripts\
xcopy %SRC_DIR%\bbin\*.bat %PREFIX%\Scripts\

%PYTHON% -m pip install . --ignore-installed -vv
