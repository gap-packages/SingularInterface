#!/bin/sh -e

if ! command -v autoreconf >/dev/null 2>&1 ; then
    echo "Please install GNU autoconf and GNU automake."
    exit 1
fi

autoreconf -vif `dirname "$0"`
