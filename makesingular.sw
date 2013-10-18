#!/bin/sh -ev

cd spielwiese/BUILD

# MAKE='remake -j -l8'
make
make check
make install
