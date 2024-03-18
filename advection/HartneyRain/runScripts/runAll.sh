#!/bin/bash -e

for res in 20 40 80 160; do
    case=cubicRK3_${res}
    echo $case
    ./runScripts/runOne.sh $case
    ./runScripts/plotErrorNorms.sh
done


