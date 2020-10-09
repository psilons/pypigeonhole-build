#!/bin/bash

export PROJ_DIR=$(pwd)
if [ ! -f "setup.py"]; then
    echo "Please go to project folder!"
    exit 1
fi
echo $PROJ_DIR

rm -rf $PROJ_DIR/build
rm -rf $PROJ_DIR/dist
rm -rf $PROJ_DIR/*.egg-info
rm -rf $PROJ_DIR/src/*.egg-info
