#!/bin/bash -e

if [ "$#" -ne 2 ]
then
   echo usage: animate.sh case var
   exit
fi

case=$1
var=$2

# Plot graphs
times=`ls -d $case/[0-9]*`
times=`filename $times | sort -n`
t=($times)
allFiles=''
for time in $times; do
    if [[ ! -a $case/$time/$var.eps ]]; then
        sed 's%CASE%'$case'%g' $case/plotScripts/$var.gmt \
            | sed 's%RASMODEL%'$time/$var'%g'\
            | sed 's%GRAPHS%'$case/postProcessing/graphs'%g' \
            | sed 's%TIME%'$time'%g' \
            > $case/plotScripts/tmp.gmt;  gmtPlot $case/plotScripts/tmp.gmt
    fi
    cp $case/$time/$var.eps $case/plotScripts/tmp.eps
#    if [[ $time == ${t[0]} ]]; then
#        ev $case/plotScripts/tmp.eps
#    fi
    allFiles="$allFiles $case/$time/$var.eps"
done

eps2gif $case/$var.gif $allFiles
rm $case/plotScripts/tmp.eps
