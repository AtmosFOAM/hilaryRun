#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: runOne.sh case
   exit
fi

case=$1

# Post process
if [ -a $case/processor0 ]; then
    reconstructPar -case $case -latestTime
fi

postProcess -latestTime -func CourantNoU
gmtFoam  -latestTime bc
ev `ls -rt */bc.pdf | tail -1`

../plots/calcNu.sh . 0 240
../plots/calcRe.sh . 0 240

