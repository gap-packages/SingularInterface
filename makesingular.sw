#!/bin/sh

cd spielwiese/src
./autogen.sh
cd -

mkdir -p spielwiese/BUILD

cd spielwiese/BUILD
../src/configure --prefix=$PWD/../../SW || exit 1
#  LDFLAGS='-ltcmalloc'

# MAKE='remake -j -l8'
make || exit 1
make check  || exit 1
make install || exit 1

