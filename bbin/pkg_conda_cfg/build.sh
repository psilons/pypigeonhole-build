#!/bin/bash

# https://python-packaging-tutorial.readthedocs.io/en/latest/conda.html
# run during packaging, not during installing
ls -ltr
ls -ltr $PREFIX

echo copying scripts to $PREFIX ...

cp $SRC_DIR/dbin/pph* $PREFIX
cp $SRC_DIR/bbin/pph* $PREFIX
dos2unix $PREFIX/*

chmod 755 $PREFIX/pph*

ls -ltr $PREFIX

$PYTHON -m pip install . --ignore-installed -vv
