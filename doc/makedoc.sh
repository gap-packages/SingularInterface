#!/bin/sh -ex

# Find GAP executable, in this way:
# 1) If a parameter is given, assume it tells us how to invoke gap.
# 2) Else, look for bin/gap.sh in a directory above ours
# 3) Else, use "gap"
if [ -x "$1" ] ; then
  GAP=$1
else
  GAPDIR=".."
  while [ -d "$GAPDIR" -a ! -x "$GAPDIR/bin/gap.sh" ] ; do
    GAPDIR="../$GAPDIR"
  done
  GAP="$GAPDIR/bin/gap.sh"
  if [ ! -x "$GAP" ] ; then
    GAP="gap"
  fi
fi

$GAP -A -q -T < makedoc.g
