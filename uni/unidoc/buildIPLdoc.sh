#!/bin/sh

# Build and install the IPL documentation

# Assumes you're running this from the unidoc source directory
UBASE=$(realpath ../..)
if [ -z "${htmldir}" ]; then
   htmldir=${UBASE}/doc
fi
SBASE=${UBASE}/ipl
TBASE=${htmldir}/ipl-api
DIRS="procs gprocs mprocs progs gprogs mprogs"
# SDIRS and LDIRS are comma-separated lists
#  (This script doesn't use LDIRS
SDIRS="${UBASE}/ipl/procs"
basetitle="Unicon IPL API"

cdir=$(pwd)
for dir in ${DIRS}; do
     echo
     echo "[Building IPL docs for ${dir}]"
     echo
     title="${basetitle} for ${dir}"
     SD=${SBASE}/${dir}
     TD=${TBASE}/${dir}
     mkdir -p ${TD}
     cd ${SD}
     unidoc --title=\"${title}\" --resolve \
            --sourcePath=${SDIRS} --linkSrc --targetDir=${TD} *.icn
     echo
     echo
     echo
     echo
done
