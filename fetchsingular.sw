#!/bin/sh

mkdir -p spielwiese

git clone --depth 1 -b spielwiese https://github.com/Singular/Sources.git spielwiese/src
# git clone --depth 1 https://github.com/Singular/Sources.git spielwiese

# curl -Lo spielwiese.tar.gz https://github.com/Singular/Sources/tarball/spielwiese
# tar -xzv -C spielwiese -f spielwiese.tar.gz 
