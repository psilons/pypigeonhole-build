#!/bin/bash

set -e

export proj_dir=$(pwd)
test -f "setup.py" || { echo "Please go to project folder!"; exit 1; }
echo Project Folder: $proj_dir

export curr_env=$CONDA_DEFAULT_ENV
echo current env: $curr_env
[ "$curr_env" != "" ] || { echo "Please activate conda env first!"; exit 1; }

[ $# != 0 ] || { echo "Please pass in <artifact path>/<artifact name>.tar.bz2"; exit 1; }

echo "Please make sure you login to anaconda already ... "

anaconda upload $1
