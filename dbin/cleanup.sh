#!/bin/bash

export CURR_DIR=$(pwd)
echo $CURR_DIR

export SCRIPT_DIR=$(dirname $(readlink -f $0))
echo $SCRIPT_DIR

export PROJ_DIR=$SCRIPT_DIR/..
echo $PROJ_DIR

rm -rf $PROJ_DIR/build
rm -rf $PROJ_DIR/dist
rm -rf $PROJ_DIR/*.egg-info
rm -rf $PROJ_DIR/src/*.egg-info
