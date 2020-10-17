#!/bin/bash

# https://python-packaging-tutorial.readthedocs.io/en/latest/conda.html

ls -ltr
ls -ltr $PREFIX

echo copying scripts to $PREFIX ...

cp -R $SRC_DIR/dbin/* $PREFIX
cp -R $SRC_DIR/bbin/* $PREFIX

ls -ltr $PREFIX

$PYTHON -m pip install .
