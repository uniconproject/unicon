#!/bin/bash
# $1 - name of program to be run under udb
# $2 - name of target

INPUT=input
OUT=local
STD=stand
DIFF=diffs

udb -line $1 < $INPUT/$2.udb &> $OUT/$2.out
echo -n [Testing $2]...
if diff -du $STD/$2.std $OUT/$2.out &> $DIFF/$2.diff ; then 
  echo Okay
else
  echo Fail
fi
exit
