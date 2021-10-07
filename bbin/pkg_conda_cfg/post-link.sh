#!/bin/bash

# Not working - not get called after installation
# echo "Running ${PKG_NAME} post-link in PREFIX=${PREFIX}"
# echo "Contents of $PREFIX"
# echo `ls ${PREFIX}`

chmod 755 ${PREFIX}/pph*

cat << EOF >> ${PREFIX}/.messages.txt

*****************************
Thanks for installing ${PKG_NAME}!
REFIX=${PREFIX}
*****************************
EOF
