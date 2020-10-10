echo %cd%

ls -ltr
ls -ltr %SRC_DIR%
ls -ltr %PREFIX%
ls -ltr "%SCRIPTS%"
REM Or use %PREFIX%\Scripts
xcopy %SRC_DIR%\dbin "%SCRIPTS%"
xcopy %SRC_DIR%\bbin "%SCRIPTS%"

RMDIR /Q /S "%SCRIPTS%"\pb_conda

%PYTHON% -m pip install . --no-deps --ignore-installed -vv
if errorlevel 1 exit /B 1
