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
$case/../../runAll/nIters.sh $case
runningMean.sh 20 $case/nExnerIter.dat > ${case}/nExnerIter.dat_smooth.dat

# Create a movie
#postProcess -func CourantNoU
#gmtFoam bc
#times=`ls -d 0 [0-9]*[0-9] | sort -n`
#file=bc.pdf
#files=
#for time in $times; do
#    if [ -a $time/$file ]; then
#        files="$files $time/$file"
#    fi
#done
#convert -scale 100% -delay 10 $files bc.mp4
