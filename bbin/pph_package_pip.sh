#!/bin/bash

export SCRIPT_DIR=$(dirname $(readlink -f $0))
echo $SCRIPT_DIR

export PROJ_DIR=$(pwd)
if [ ! -f "setup.py"]; then
    echo "Please go to project folder!"
    exit 1
fi
echo $PROJ_DIR

$SCRIPT_DIR/pph_cleanup.sh

python setup.py bdist_wheel sdist

mv $PROJ_DIR/src/*.egg-info $PROJ_DIR
