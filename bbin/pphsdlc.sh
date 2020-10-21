#!/bin/bash

set -e

export script_dir=$(dirname $(readlink -f $0))
echo Script Folder: $script_dir

export proj_dir=$(pwd)
test -f "setup.py" || { echo "Please go to project folder!"; exit 1; }
echo Project Folder: $proj_dir

if [ $# == 0 ] || [ "$1" == "help" ]; then
    echo ""
    echo "Options are:"
    echo "    - setup: create conda environment specified in dep_setup.py"
    echo "    - test: run unit tests and collect coverage"
    echo "    - package: package artifact with pip | conda | zip"
    echo "    - upload: upload to pip | piptest | conda"
    echo "    - release: tag the current version in git and then bump the version"
    echo "    - cleanup: cleanup intermediate results in filesystem"
    echo "    - help or without parameter: this menu"
    echo ""

    exit 0
fi

if [ "$1" == "setup" ]; then $script_dir/pph_dev_env_setup.sh; exit 0; fi

if [ "$1" == "test" ]; then $script_dir/pph_unittest.sh; exit 0; fi

if [ "$1" == "package" ]; then
    if [ $# == 1 ]; then
        echo "Please supply package type: pip | conda | zip"
        exit 1
    fi

    if [ "$2" == "pip" ]; then $script_dir/pph_package_pip.sh; exit 0; fi

    if [ "$2" == "conda" ]; then $script_dir/pph_package_conda.sh; exit 0; fi

    if [ "$2" == "zip" ]; then $script_dir/pph_pack_app_zip.sh; exit 0; fi

    echo "Unknown package type, type pphsdlc without parameter for help."
fi

if [ "$1" == "upload" ]; then
    if [ $# == 1 ]; then
        echo "Please supply target info: pip | piptest | conda"
        exit 1
    fi

    if [ "$2" == "pip" ]; then $script_dir/pph_upload_pip.sh $3; exit 0; fi

    if [ "$2" == "conda" ]; then $script_dir/pph_upload_conda.sh $3; exit 0; fi

    echo "Unknown upload target, type pphsdlc without parameter for help."
fi

if [ "$1" == "release" ]; then $script_dir/pph_release.sh; exit 0; fi

if [ "$1" == "cleanup" ]; then $script_dir/pph_cleanup.sh; exit 0; fi

echo "Unknown option, type pphsdlc without parameter for help."
