#!/bin/sh

#
# This shell script attempts to automatically assign the correct platform name
# for UNIX-based configurations.
#
SYS=`uname -a | sed 's/ /_/g'`
case "$SYS" in
   Darwin*_x86_64)
      if [ $SHLVL -lt 3 ]; then { make build name=x86_64_macos; }; else { echo "Can't run interactive options menu at shell level $SHLVL"; }; fi;;
   Darwin*Version_10*i386)
      if [ $SHLVL -lt 3 ]; then { make build name=x86_64_macos; }; else { echo "Can't run interactive options menu at shell level $SHLVL"; }; fi;;
   Darwin*Version_9*i386)
      make build name=x86_32_macos;;
   Darwin*Power_Macintosh)
      make build name=ppc_macos;;
   Darwin*powerpc)
      make build name=ppc_macos;;
   FreeBSD*i386)
      make build name=x86_32_freebsd;;
   Linux*alpha*)
      make build name=alpha_linux;;
   Linux*i686*)
      make build name=x86_32_linux;;
   Linux*sparc64*)
      make build name=sun_linux;;
   Linux*x86_64*)
      make build name=x86_64_linux;;
   SunOS*sparc*)
      make build name=sparc_solaris;;
   SunOS*i86pc)
      make build name=x86_64_solaris;;
   *)
      echo 1>&2 "don't know how to select configuration for $SYS, use 'make [X-]Configure name=system'"
      exit 1;;
esac

