#!/bin/bash

set -e

export proj_dir=$(pwd)
test -f "setup.py" || { echo "Please go to project folder!"; exit 1; }
echo Project Folder: $proj_dir

export proj_name=$(basename $proj_dir)
echo project name: $proj_name

rm -rf $proj_dir/dist_zip
mkdir $proj_dir/dist_zip

tar -czf $proj_dir/dist_zip/$proj_name.tar.gz bin conf dist

echo "Done, check result in dist_zip"
