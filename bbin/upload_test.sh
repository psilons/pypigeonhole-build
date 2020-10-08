export CURR_DIR=$(pwd)
echo $CURR_DIR

export SCRIPT_DIR=$(dirname $(readlink -f $0))
echo $SCRIPT_DIR

export PROJ_DIR=$SCRIPT_DIR/..
echo $PROJ_DIR

export PROJ_NAME=$(basename $PROJ_DIR)

twine upload -r testpypi %ProjDir%/dist/*
