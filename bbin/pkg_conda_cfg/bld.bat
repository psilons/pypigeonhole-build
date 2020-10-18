echo %cd%

ls -ltr
ls -ltr %SRC_DIR%
ls -ltr %PREFIX%
ls -ltr "%SCRIPTS%"
REM Or use %PREFIX%\Scripts

REM Windows uses this folder to transport files from package to target env / Scripts folder.
echo copying scripts to %SCRIPTS%...
xcopy %SRC_DIR%\dbin "%SCRIPTS%"
xcopy %SRC_DIR%\bbin "%SCRIPTS%"

%PYTHON% -m pip install .
