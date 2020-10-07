#!/bin/bash

export CURR_DIR=$(pwd)
echo $CURR_DIR

export SCRIPT_DIR=$(dirname $(readlink -f $0))
echo $SCRIPT_DIR

export PROJ_DIR=$SCRIPT_DIR/..
echo $PROJ_DIR

$SCRIPT_DIR/cleanup.sh

cd $PROJ_DIR
python setup.py bdist_wheel sdist

mv $PROJ_DIR/src/*.egg-info $PROJ_DIR

cd $CURR_DIR
