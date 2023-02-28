#!/bin/bash -e

caseRoot=runs/BTBS
for nIter in 0 1 2 5 10 20; do
    for solver in PBiCGStab GAMG  ; do
        echo ${caseRoot}_it${nIter}_${solver}
        ./scripts/runOne.sh $caseRoot init $nIter $solver
        ./scripts/runOne.sh $caseRoot run $nIter $solver
        ls ${caseRoot}_it${nIter}_${solver}
    done
done

