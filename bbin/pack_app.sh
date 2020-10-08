#!/bin/bash

export CURR_DIR=$(pwd)
echo $CURR_DIR

export SCRIPT_DIR=$(dirname $(readlink -f $0))
echo $SCRIPT_DIR

export PROJ_DIR=$SCRIPT_DIR/..
echo $PROJ_DIR

export PROJ_NAME=$(basename $PROJ_DIR)

cd $PROJ_DIR

if [ -d "$PROJ_DIR/dist"]; then
    rm -rf $PROJ_DIR/dist
fi
mkdir $PROJ_DIR/dist

tar -czf $PROJ_DIR/dist/$PROJ_NAME.tar.gz bin conf src

cd $CURR_DIR
