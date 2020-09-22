#!/bin/sh

# Build and install the UniDoc documentation

# You must reset UBASE for your system's location of Unicon.
UBASE=/opt/unicon
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
