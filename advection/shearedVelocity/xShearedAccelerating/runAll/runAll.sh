#!/bin/bash -e

MPDATAtype=expGauge
c=05

for res in 20 40 80; do
    ./runAll/runOne.sh $res $c $MPDATAtype
    case=`echo *x${res}/c${c}_${MPDATAtype}`
    ./runAll/plotOne.sh $case
done

