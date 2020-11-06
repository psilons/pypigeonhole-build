#!/bin/bash

set -e

export proj_dir=$(pwd)
test -f "setup.py" || { echo "Please go to project folder!"; exit 1; }
echo Project Folder: $proj_dir

export curr_env=$CONDA_DEFAULT_ENV
echo current env: $curr_env
[ "$curr_env" != "" ] || { echo "Please activate conda env first!"; exit 1; }

export repo=$1
if [ "$1" == "" ]; then
    export repo=$PIP_UPLOAD_REPO
    if [ "$1" == "" ]; then
        export repo=pypi
    fi
fi

echo use PIP repository: $repo

export conf_file=${PYPI_CONF_FILE:-~/.pypirc}
echo use PYPI RC file: $conf_file

twine upload -r $repo --config-file $conf_file $proj_dir/dist/*
