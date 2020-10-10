#!/bin/bash

ls -ltr
ls -ltr $SRC_DIR
ls -ltr $PREFIX
ls -ltr $SCRIPTS
REM Or use %PREFIX%\Scripts
cp -R $SRC_DIR\dbin $SCRIPTS
cp -R $SRC_DIR\bbin $SCRIPTS

rm -rf "$SCRIPTS"\pb_conda

$PYTHON -m pip install . --no-deps --ignore-installed -vv
if errorlevel 1 exit 1
