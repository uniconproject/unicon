#!/bin/sh

# Build and install the UniDoc documentation

# Assumes you're running this from the unidoc source directory
UBASE=../..
SBASE=${UBASE}/uni/lib
TBASE=${UBASE}/doc/uni-api
title="Unicon Uni Lib API"

echo
echo "[Building docs for ${title}]"
echo "UBASE is ${UBASE}"
echo
mkdir -p ${TBASE}
cd ${SBASE}
UniDoc --title="${title}" --linkSrc \
       --sourcePath=${SBASE} \
       --resolve --targetDir=${TBASE} *.icn
