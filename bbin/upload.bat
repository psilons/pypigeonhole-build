SET BatchDir=%~dp0
SET ProjDir=%BatchDir%..

echo Project Folder: %ProjDir%

twine upload -r pypi %ProjDir%/dist/*
