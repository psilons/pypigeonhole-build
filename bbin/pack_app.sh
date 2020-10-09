#!/bin/bash

export PROJ_DIR=$(pwd)
if [ ! -f "setup.py"]; then
    echo "Please go to project folder!"
    exit 1
fi
echo $PROJ_DIR

if [ -d "$PROJ_DIR/dist"]; then
    rm -rf $PROJ_DIR/dist
fi
mkdir $PROJ_DIR/dist

tar -czf $PROJ_DIR/dist/$PROJ_NAME.tar.gz bin conf src
