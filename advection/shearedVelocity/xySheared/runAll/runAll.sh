#!/bin/bash -e

MPDATAtype=expGauge
#MPDATAtype=upwind
c=05

for res in 40 80 160; do
    ./runAll/runOne.sh $res $c $MPDATAtype
    case=`echo ${res}x${res}/c${c}_${MPDATAtype}`
    ./runAll/plotOne.sh $case
done

