#!/bin/bash

set -e

export proj_dir=$(pwd)
test -f "setup.py" || { echo "Please go to project folder!"; exit 1; }
echo Project Folder: $proj_dir

rm -rf $proj_dir/build
rm -rf $proj_dir/dist
rm -rf $proj_dir/*.egg-info
rm -rf $proj_dir/src/*.egg-info
