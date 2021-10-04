#!/bin/bash

# https://python-packaging-tutorial.readthedocs.io/en/latest/conda.html

ls -ltr
ls -ltr $PREFIX

echo copying scripts to $PREFIX ...

cp -R $SRC_DIR/dbin/*.sh $PREFIX/bin
cp -R $SRC_DIR/bbin/*.sh $PREFIX/bin

for f in $PREFIX/bin/pph*.sh; do
    sed 's/\r//g' < $f > $f
done

chmod 755 $PREFIX/bin/pph*

ls -ltr $PREFIX

$PYTHON -m pip install .
