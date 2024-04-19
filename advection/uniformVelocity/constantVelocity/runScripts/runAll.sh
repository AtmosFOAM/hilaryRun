#!/bin/bash -e

for c in 08 1p6 2 2p5 5 10; do
    for res in 20 40 80 160; do
        case=cubicRK3_${res}_c${c}
        echo $case
        ./runScripts/runOne.sh $case
    done
done
./runScripts/plotErrorNorms.sh
./runScripts/plotDiags.sh

for case in cubicRK3_40_c10 cubicRK3_40_c1p6; do
    ln -s ../0/T $case/1/T0
    gmtFoam -case $case -time 1 T
    ev $case/1/T.pdf
done

