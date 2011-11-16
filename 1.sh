#!/bin/sh

# make clean

# P="/GITHUB/w/LINBOX"
# CXX="clang" LIBS="-lstdc++" 

##./configure --prefix=$P && make -j9 install

# --without-blas 

# --prefix=$P 

## ./autogen.sh 

# && ./configure --with-libpolys=$P && make -j9 all && make -j9 -i -k check
# -i -k install



./configure --with-libSingular=/mnt/DATA/GITHUB/w/GAP/libsing/spielwiese/TARGET --with-gaproot=/mnt/DATA/GITHUB/w/GAP/gap4r5
