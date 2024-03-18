#!/bin/bash -e

for res in 40 80 160 320; do
    for c in 025 05 1 2 4; do
        for MPDATAtype in exp imp impExp exp_upImp; do
            resDir=${res}x${res}
            case=c${c}_${MPDATAtype}
            ./plotOne.sh $resDir $case
        done
    done
done

