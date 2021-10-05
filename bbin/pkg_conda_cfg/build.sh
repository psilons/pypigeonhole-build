#!/bin/bash

# https://python-packaging-tutorial.readthedocs.io/en/latest/conda.html
# run during packaging, not during installing
ls -ltr
ls -ltr $PREFIX

echo copying scripts to $PREFIX ...

cp $SRC_DIR/dbin/pph* $PREFIX/bin
cp $SRC_DIR/bbin/pph* $PREFIX/bin

for f in $PREFIX/bin/pph*; do
    sed 's/\r//g' < $f > $f
done

chmod 755 $PREFIX/bin/pph*

ls -ltr $PREFIX

$PYTHON -m pip install .
