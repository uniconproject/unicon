#!/bin/sh

# Build and install the UniDoc documentation

LBASE=/opt/unicon/ipl
SBASE=${HOME}/.src/Unicon/Samples/UniDoc
TBASE=/var/www/html/unicon/unisamples/UniDoc
title="UniDoc Code Generator"

echo
echo "[Building docs for ${title}]"
echo "UBASE is ${UBASE}"
echo
mkdir -p ${TBASE}
cd ${SBASE}
UniDoc --title="${title}" --linkSrc \
       --sourcePath=${SBASE}/../../Classes \
       --resolve --targetDir=${TBASE} *.icn
