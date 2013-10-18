#!/bin/sh -ev

cd spielwiese/src
./autogen.sh
cd ../..

mkdir -p spielwiese/BUILD

PREFIX=$PWD/SW

cd spielwiese/BUILD
../src/configure --prefix=$PREFIX
#  LDFLAGS='-ltcmalloc'
