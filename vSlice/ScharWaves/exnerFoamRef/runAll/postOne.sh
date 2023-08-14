#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: postOne.sh case
   exit
fi

case=$1

# Post porcessing
#reconstructPar -case $case; rm -r $case/processor*/[1-9]*; \
writeuvw -case $case -latestTime U
gmtFoam -case $case -latestTime w
#    ev 18000/w.pdf

