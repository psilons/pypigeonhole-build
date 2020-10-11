#!/bin/bash

ls -ltr
ls -ltr $SRC_DIR
ls -ltr $PREFIX
ls -ltr $SCRIPTS
REM Or use %PREFIX%\Scripts
cp -R $SRC_DIR\dbin $SCRIPTS
cp -R $SRC_DIR\bbin $SCRIPTS

$PYTHON -m pip install . --no-deps --ignore-installed -vv
