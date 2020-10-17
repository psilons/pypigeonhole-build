#!/bin/bash

set -e

export script_dir=$(dirname $(readlink -f $0))
echo Script Folder: $script_dir

export proj_dir=$(pwd)
test -f "setup.py" || { echo "Please go to project folder!"; exit 1; }
echo Project Folder: $proj_dir

export curr_env=$CONDA_DEFAULT_ENV
echo current env: $curr_env
[ "$curr_env" != "" ] || { echo "Please activate conda env first!"; exit 1; }

$script_dir/pph_cleanup.sh

python setup.py bdist_wheel sdist
