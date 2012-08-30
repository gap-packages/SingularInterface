#!/bin/sh

cd spielwiese/src
./autogen.sh
cd -

mkdir -p spielwiese/BUILD

cd spielwiese/BUILD
../src/configure --disable-debug --without-dynamic-kernel --without-MP --prefix=$PWD/../../SW || exit 1
#  LDFLAGS='-ltcmalloc'

MAKE='make -j9'
make || exit 1
make check  || exit 1
make install || exit 1

