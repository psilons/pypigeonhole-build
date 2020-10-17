#!/bin/bash

# exit if error occurs at any line
set -e

export proj_dir=$(pwd)
test -f "setup.py" || { echo "Please go to project folder!"; exit 1; }
echo Project Folder: $proj_dir

export curr_env=$CONDA_DEFAULT_ENV
echo current env: $curr_env
[ "$curr_env" != "" ] || { echo "Please activate conda env first!"; exit 1; }

which conda
which python

coverage run --omit test/* -m unittest discover -s test
coverage report --omit test/*

rm -rf coverage.svg
conda run coverage-badge -o coverage.svg

echo "Done."