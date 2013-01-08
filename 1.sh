#!/bin/sh

# make clean

# P="/GITHUB/w/LINBOX"
# CXX="clang" LIBS="-lstdc++" 

##./configure --prefix=$P && make -j9 install

# --without-blas 

# --prefix=$P 

./autogen.sh 

# && ./configure --with-libpolys=$P && make -j9 all && make -j9 -i -k check
# -i -k install



./configure --with-sw --with-libSingular=$PWD/SW --with-gaproot=$PWD/../GAP 

make

