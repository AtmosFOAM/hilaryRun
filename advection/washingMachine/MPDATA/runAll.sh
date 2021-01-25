#!/bin/bash -e

for res in 40 80 160 320; do
    for c in 025 05 1 2 4; do
        for MPDATAtype in exp imp impExp exp_upImp; do
            ./runOne.sh $res $c $MPDATAtype
        done
    done
done

