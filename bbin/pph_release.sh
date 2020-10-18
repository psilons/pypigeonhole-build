#!/bin/bash

export proj_dir=$(pwd)
test -f "setup.py" || { echo "Please go to project folder!"; exit 1; }
echo Project Folder: $proj_dir

export curr_env=$CONDA_DEFAULT_ENV
echo current env: $curr_env
[ "$curr_env" != "" ] || { echo "Please activate conda env first!"; exit 1; }

export proj_name=$(basename $proj_dir)
echo project name: $proj_name
export pkg=$(echo $proj_name | tr - _)
echo top package name: $pkg

[ -f "src/$pkg/app_setup.py" ] || { echo "Please create app_setup.py in <project>/src/$pkg first!"; exit 1; }


git status

export app_version=$(python setup.py --version)
echo app version: $app_version

git tag -a $app_version -m "release: tag version %app_version%"

git pull
git push --tags
[ $? -eq 0 ] || { echo "Tagging failed"; exit 1; }

export PYTHONPATH=src:$PYTHONPATH
export new_version=$(python -c "import pypigeonhole_build.app_version_control as fu; import $pkg.app_setup; print(fu.bump_version('$app_version', 'src/$pkg/app_setup.py'))")
[ $? -eq 0 ] || { echo "New version retrieval failed"; exit 1; }
echo new version: $new_version

git add src/$pkg/app_setup.py
git commit -m "release: bump version $app_version up to $new_version"

git pull
git push
[ $? -eq 0 ] || { echo "Version bump failed"; exit 1; }

echo "Done, check new version in src/$pkg/app_setup.py"
