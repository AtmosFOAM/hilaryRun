#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: postOne.sh case
   exit
fi

case=$1

#reconstructPar; rm -r processor*/[1-9]*; \
postProcess -case $case -func CourantNoU -latestTime
gmtFoam -case $case -latestTime thetaC
#    ev 1000/thetaC.pdf

