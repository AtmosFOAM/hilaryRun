#!/bin/bash -e

for case in A-grid*; do
    ./runAgrid.sh $case
done


for case in C-grid*; do
    ./runCgrid.sh $case
done

# Plot all
time=1e+06
for case in A-grid* C-grid*; do
    if [[ -a $case/$time ]]; then
        gmtFoam -time $time -case $case b >& /dev/null
        gv $case/$time/b.pdf &
    else
        echo no $case/$time
    fi
done

