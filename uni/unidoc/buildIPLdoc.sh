#!/bin/zsh -f

# Build and install the IPL documentation

SBASE=/opt/unicon/ipl
TBASE=/var/www/html/unicon/ipl
DIRS=(procs gprocs mprocs progs gprogs mprogs)

cdir=$(pwd)
for dir in ${DIRS}; do
     echo
     echo "[Building IPL docs for ${dir}]"
     echo
     echo -n "Please enter the title for this section: "
     read title
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
