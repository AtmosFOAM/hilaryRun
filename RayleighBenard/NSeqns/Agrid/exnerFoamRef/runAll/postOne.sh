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

postProcess -case $case -latestTime -func CourantNoU
gmtFoam -case $case -latestTime bc
#ev `ls -rt $case/*/bc.pdf | tail -1`

$case/../../runAll/calcNu.sh $case 0 240
$case/../../runAll/calcRe.sh $case 0 240

