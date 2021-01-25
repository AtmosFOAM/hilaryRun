#!/bin/bash -e

for res in 80 160 320; do
    for c in 1 2 4 ; do
        for MPDATAtype in imp exp_upImp impExp ; do
            ./runOne.sh $res $c $MPDATAtype
            case=${res}x${res}/c${c}_${MPDATAtype}
            ./plotOne.sh $case >& $case/plotLog &
        done
    done
done

for res in 80 160 320; do
    for c in 05 ; do
        for MPDATAtype in imp exp; do
            ./runOne.sh $res $c $MPDATAtype
            case=${res}x${res}/c${c}_${MPDATAtype}
            ./plotOne.sh $case >& $case/plotLog &
        done
    done
done

./plotConvergence.sh
./plotMinMax.sh

