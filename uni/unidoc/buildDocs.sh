#!/bin/sh

# Build and install the UniDoc documentation

# Assumes you're running this from the unidoc source directory
UBASE=$(realpath ../..)
SBASE=${UBASE}/uni
TBASE=${UBASE}/doc/uni-api
DIRS="lib unidoc"
# SDIRS and LDIRS are comma-separated lists
SDIRS="${SBASE}/lib,${UBASE}/ipl/procs"
LDIRS="${TBASE}/lib"
basetitle="Unicon Uni API "

cdir=$(pwd)
for dir in ${DIRS}; do
     echo
     echo "[Building API docs for ${dir}]"
     echo
     title="${basetitle} for ${dir}"
     SD=${SBASE}/${dir}
     TD=${TBASE}/${dir}
     mkdir -p ${TD}
     cd ${SD}
     /opt/unicon/uni/unidoc/UniDoc --title="${title}" --linkSrc \
            --sourcePath=${SDIRS} \
            --linkPath=${LDIRS} \
            --resolve --targetDir=${TD} *.icn
     cd ${cdir}
     echo
     echo
     echo
     echo
done

