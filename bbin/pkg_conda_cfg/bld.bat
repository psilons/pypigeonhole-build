echo %cd%

ls -ltr
ls -ltr %SRC_DIR%
ls -ltr %PREFIX%
ls -ltr "%SCRIPTS%"
REM Or use %PREFIX%\Scripts
xcopy %SRC_DIR%\dbin "%SCRIPTS%"
xcopy %SRC_DIR%\bbin "%SCRIPTS%"

%PYTHON% -m pip install . --no-deps --ignore-installed -vv
