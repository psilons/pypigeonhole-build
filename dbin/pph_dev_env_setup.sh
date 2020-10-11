#!/bin/bash

export PROJ_DIR=$(pwd)
if [ ! -f "setup.py"]; then
    echo "Please go to project folder!"
    exit 1
fi
echo $PROJ_DIR

if [ ! -f "src/dep_setup.py"]; then
    echo "Please create dep_setup.py in project src first!"
    exit 1
fi

python src/dep_setup.py conda

python src/dep_setup.py pip

export new_env=$(python src/dep_setup.py conda_env)
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
