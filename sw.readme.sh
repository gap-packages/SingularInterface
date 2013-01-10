#!/bin/sh

./autogen.sh 
./configure --with-sw --with-libSingular=$PWD/SW --with-gaproot=$PWD/../GAP 
make clean

make V=0
$PWD/../GAP/bin/gap.sh tst/testall.g
