#!/bin/sh
SYS=`uname -ms | sed 's/ /_/' | sed 's/x86_64/amd64/' | sed 's/Linux/linux/' | sed 's/x86/intel/'`
case "$SYS" in
   linux_amd64)
      make build name=amd64_linux;;
   linux_intel)
      make build name=intel_linux;;
   *)
      echo 1>&2 "don't know how to select configuration for $SYS, use 'make [X-]Configure name=system'"
      exit 1;;
esac

