#!/bin/bash

f=./plugs/$1-collect_stats.sh
shift

if [ -f $f ]; then 
  bash $f $*
else
  echo "Could not find statistics collection script at $f"
  exit 1
fi

