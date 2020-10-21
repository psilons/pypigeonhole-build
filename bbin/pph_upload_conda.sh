#!/bin/bash

set -e

export proj_dir=$(pwd)
test -f "setup.py" || { echo "Please go to project folder!"; exit 1; }
echo Project Folder: $proj_dir

export curr_env=$CONDA_DEFAULT_ENV
echo current env: $curr_env
[ "$curr_env" != "" ] || { echo "Please activate conda env first!"; exit 1; }

[ $# != 0 ] || { echo "Please pass in <artifact path>/<artifact name>.tar.bz2"; exit 1; }

SET channel=$CONDA_UPLOAD_CHANNEL

# use anaconda
if [ "$channel" == "" ]; then
    for f in $(find dist_conda -name "*.tar.bz2"); do
        echo "upload files: $f ..."
        anaconda upload $f
    done

    echo done
    exit 0
fi

# use local file
if [[ $channel == file://* ]]; then
    echo "file channel: $channel"
    export target=${channel#"file://"}
    echo "target root folder: $target"

    for f in $(find dist_conda -name "*.tar.bz2"); do
        echo "copying file: $f ..."
        arch=$(basename $(dirname $f))
        echo arch folder: $arch
        yes | cp $f $target/$arch/
    done

    echo "done"
fi

echo unknown destination
