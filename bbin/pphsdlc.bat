@echo off
SET script_dir=%~dp0

if "%~1" == "" GOTO menu
if "%~1" == "help" GOTO menu

if "%~1" == "setup" (
    CALL %script_dir%pph_dev_env_setup.bat
    GOTO end
)

if "%~1" == "test" (
    CALL %script_dir%pph_unittest.bat
    GOTO end
)

if "%~1" == "package" (
    if "%~2" == "" (
        echo Please supply package type: pip ^| conda ^| zip
        exit /B 1
    )

    if "%~2" == "pip" (
        CALL %script_dir%pph_package_pip.bat
        GOTO end
    )

    if "%~2" == "conda" (
        CALL %script_dir%pph_package_conda.bat
        GOTO end
    )

    if "%~2" == "zip" (
        CALL %script_dir%pph_pack_app_zip.bat
        GOTO end
    )

    echo Unknown package type
    GOTO menu
)

if "%~1" == "upload" (
    if "%~2" == "" (
        echo Please supply target info: pip ^| piptest ^| conda
        exit /B 1
    )

    if "%~2" == "pip" (
        CALL %script_dir%pph_upload_pip.bat %3
        GOTO end
    )

    if "%~2" == "conda" (
        CALL %script_dir%pph_upload_conda.bat %3
        GOTO end
    )

    echo Unknown upload target
    GOTO menu
)

if "%~1" == "release" (
    CALL %script_dir%pph_release.bat
    GOTO end
)

if "%~1" == "cleanup" (
    CALL %script_dir%pph_cleanup.bat
    GOTO end
)

echo Unknown option

:menu
echo.
echo Options are:
echo     - setup: create conda environment specified in dep_setup.py
echo     - test: run unit tests and collect coverage
echo     - package: package artifact with pip ^| conda ^| zip
echo     - upload: upload to pip ^| piptest ^| conda
echo     - release: tag the current version in git and then bump the version
echo     - cleanup: cleanup intermediate results in filesystem
echo     - help or without parameter: this menu
echo.

:end
