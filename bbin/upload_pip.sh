export PROJ_DIR=$(pwd)
if [ ! -f "setup.py"]; then
    echo "Please go to project folder!"
    exit 1
fi
echo $PROJ_DIR

twine upload -r pypi %ProjDir%/dist/*
