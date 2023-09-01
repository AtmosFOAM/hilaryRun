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
ev `ls -rt $case/*/w.pdf | tail -1`
#mkdir -p $case/plots
#gmtPlot gmtDicts/energy.gmt

logStats.sh $case Exnerp
