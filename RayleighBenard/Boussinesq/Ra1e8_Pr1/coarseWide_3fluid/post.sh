#!/bin/bash -e

# Post processing
case=.
startAverageTime=32
time=150

# Plots at given time
sumFields $time sigmaDiff $time sigma.up $time sigma.down -scale1 -1
for var in ub uSigma up down stable; do
    gmtFoam -time $time $var
    ev $time/$var.pdf
done

# Scatter plot of results
../../scripts/scatter.sh $case $time 'stable up down'

# Calculate Nusselt number and KE
../../scripts/Nusselt.sh $case 0 $startAverageTime
../../scripts/KE.sh $case 0 $startAverageTime 'stable up down'

