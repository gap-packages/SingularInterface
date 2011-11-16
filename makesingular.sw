#!/bin/sh

cd spielwiese/src
./autogen.sh
cd -

mkdir -p spielwiese/build

cd spielwiese/build
../src/configure --without-dynamic-kernel --without-MP --prefix=`pwd`/../target

MAKE='make -j9'
make
make check 
make install

# if [ `uname` = "Darwin" ] ; then
#    echo "Setting libsingular.dylib load path (because of MacOS)"
#    install_name_tool -id $PWD/Singular-${SINGULARVERSION}/Singular/libsingular.dylib Singular/libsingular.dylib
# fi
# ./singuname.sh >../SINGARCHNAME

