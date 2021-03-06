@echo off

SET ProjDir=%cd%
IF NOT EXIST setup.py (
    ECHO Please go to project folder!
    EXIT /B 1
)
echo Project Folder: %ProjDir%

SET curr_env=%CONDA_DEFAULT_ENV%
ECHO current env: %curr_env%
IF "%curr_env%" == "" (
    echo Please activate conda env first!
)

REM conda convert --platform all %pkg% -o conda_output/

SET channel=%CONDA_UPLOAD_CHANNEL%
REM use anaconda
if "%channel%" == "" (
    for /f "delims=" %%I in ('dir dist_conda\* /s/b ^| findstr \.tar.bz2$') do (
        echo upload file: %%I ...
        anaconda upload %%I
    )

    echo done
    exit /B 0
)

REM use local file
if "%channel:~0,8%" == "file:///" (
    echo file channel: %channel%
    set target=%channel:~8%
    echo target root folder: %target%

    echo set permission on channel ...
    icacls %target% /grant Everyone:M

    for /f "delims=" %%I in ('dir dist_conda\* /s/b ^| findstr \.tar.bz2$') do (
        echo copying file: %%I ...

        for %%a in ("%%I") do for %%b in ("%%~dpa\.") do set "arch=%%~nxb"
        echo platform folder: %target%\%arch%
        xcopy /Y %%I %target%\%arch%
    )

    echo index repo ...
    conda index %target%

    echo indexing is done, please run: conda search <lib name> to verify
    echo done
    exit /B 0
)

echo unknown destination
exit /B 1
