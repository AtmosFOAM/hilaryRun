#!/bin/bash -e

time=5
meshType=orthogonal
c=05
MPDATAtype=expGauge
for ny in 60 120 240 480; do
    case=`./runAll/runOne.sh $ny $meshType $c $MPDATAtype`
    #./runAll/plotOne.sh $case $time
done

