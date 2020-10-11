#!/bin/bash

export PROJ_DIR=$(pwd)
if [ ! -f "setup.py"]; then
    echo "Please go to project folder!"
    exit 1
fi
echo $PROJ_DIR

pwd
ls -ltr
conda info
conda list
which conda
which python

conda run coverage run --omit test/* -m unittest discover -s test
conda run coverage report --omit test/*

rm -rf coverage.svg
conda run coverage-badge -o coverage.svg
