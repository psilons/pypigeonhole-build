#!/bin/bash

export proj_dir=$(pwd)
test -f "setup.py" || { echo "Please go to project folder!"; exit 1; }
echo Project Folder: $proj_dir

export proj_name=$(basename $proj_dir)
echo project name: $proj_name
export pkg=$(echo $proj_name | tr - _)
echo top package name: $pkg

test -f "src/$pkg/dep_setup.py" || { cho "Please create dep_setup.py in $proj_dir/src/$pkg first!"; exit 1; }
#if [ ! -f "src/$pkg/dep_setup.py" ]; then
#    echo "Please create dep_setup.py in $proj_dir/src/$pkg first!"
#    exit 1
#fi

export PYTHONPATH=src:$PYTHONPATH

echo create conda environment.yml
python src/$pkg/dep_setup.py conda
[ $? -eq 0 ] || { echo "error on generating environment.yml"; exit 1; }

echo create pip requirements.txt
python src/$pkg/dep_setup.py pip
[ $? -eq 0 ] || { echo "error on generating requirements.txt"; exit 1; }

export new_env=$(python src/$pkg/dep_setup.py conda_env)
[ $? -eq 0 ] || { echo "error on getting new env"; exit 1; }
echo new env: $new_env

export conda_base=$(conda info --base)
source $conda_base/etc/profile.d/conda.sh

conda info --envs

export curr_env=$CONDA_DEFAULT_ENV
echo current env: $curr_env

if [ "$curr_env" != "" ]; then  # this is why we do not use set -e
    conda deactivate
    [ $? -eq 0 ] || { echo "can't deactivate curr env"; exit 1; }
    echo current env after deactivate: $CONDA_DEFAULT_ENV
fi

echo create new env ...
conda env create -f environment.yaml

if [[ $? -ne 0 ]]; then
    echo env[$new_env] exists, removing it ...
    conda env remove -n $new_env
    [ $? -eq 0 ] || { echo "can't remove existing env"; exit 1; }

    echo create new env again ...
    conda env create -f environment.yml
    [ $? -eq 0 ] || { echo "can't create new env"; exit 1; }

fi

conda activate $new_env
[ $? -eq 0 ] || { echo "can't activate new env"; exit 1; }
echo current conda env: %CONDA_DEFAULT_ENV%
pipdeptree

conda deactivate

echo --
echo run "conda activate $new_env" to activate environment
echo --
echo run "conda info --envs" to check current activated environment
echo --
