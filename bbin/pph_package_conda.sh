#!/bin/bash

set -e

export proj_dir=$(pwd)
test -f "setup.py" || { echo "Please go to project folder!"; exit 1; }
echo Project Folder: $proj_dir

export curr_env=$CONDA_DEFAULT_ENV
echo current env: $curr_env
[ "$curr_env" != "" ] || { echo "Please activate conda env first!"; exit 1; }

rm -rf $proj_dir/dist_conda

conda-build bbin/pkg_conda_cfg --output-folder dist_conda

conda build purge

echo "Done."