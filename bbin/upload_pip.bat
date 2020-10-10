SET ProjDir=%cd%
IF NOT EXIST setup.py (
    ECHO Please go to project folder!
    EXIT /B 1
)
echo Project Folder: %ProjDir%

REM make sure the setup in ~/.pyirc has pypi entry
twine upload -r pypi %ProjDir%/dist/*
