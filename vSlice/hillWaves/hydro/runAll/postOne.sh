#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: postOne.sh case
   exit
fi

case=$1

if [ -a $case/processor0 ]; then
    reconstructPar -case $case
    rm -r $case/processor*/[1-9]*
fi

writeuvw -case $case -latestTime U
gmtFoam -case $case -latestTime w
#mkdir -p $case/plots
#gmtPlot gmtDicts/energy.gmt

logStats.sh $case Exnerp
