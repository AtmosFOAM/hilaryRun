#!/bin/bash -e

for res in 40 80; do
    MPDATAtype=expGauge
    c=05

    ./runAll/runOne.sh $res $c $MPDATAtype

    case=`echo ${res}x${res}/c${c}_${MPDATAtype}`
    ./runAll/plotOne.sh $case
done

