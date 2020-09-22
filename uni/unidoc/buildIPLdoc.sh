#!/bin/zsh -f

# Build and install the IPL documentation

# You must reset UBASE for your system's location of Unicon.
UBASE=/opt/unicon
SBASE=${UBASE}/ipl
TBASE=${UBASE}/doc/ipl-api
DIRS=(procs gprocs mprocs progs gprogs mprogs)
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
     UniDoc --title="${title}" --resolve --linkSrc --targetDir=${TD} *.icn
     echo
     echo
     echo
     echo
done
