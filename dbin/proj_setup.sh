#!/bin/bash

export CURR_DIR=$(pwd)
echo $CURR_DIR

export SCRIPT_DIR=$(dirname $(readlink -f $0))
echo $SCRIPT_DIR

export PROJ_DIR=$SCRIPT_DIR/..
echo $PROJ_DIR

cd $PROJ_DIR

if [ ! -f "dep_setup.py"]; then
    echo "Please create dep_setup.py in project root first!"
    exit 1
fi

export new_env=$(python dep_setup.py)
echo "new_env: $new_env"

conda env create -f environment.yaml

if [ $? -eq 0 ]
then
    conda activate $new_env
    pipdeptree
    exit 0
else
    export curr_env=$CONDA_DEFAULT_ENV
    echo "curr_env: $curr_env"

    if [ "$curr_env" != "" ]
    then
        if [ "$curr_env" == "$new_env" ]; then
            conda deactivate $$curr_env
        fi
    fi

    conda env remove -n $$new_env
    conda env create -f environment.yaml
    conda activate $new_env
    pipdeptree
fi

cd $CURR_DIR
