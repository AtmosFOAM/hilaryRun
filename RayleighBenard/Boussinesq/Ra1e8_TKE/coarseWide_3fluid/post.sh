#!/bin/bash -e

# Post processing
case=.
startAverageTime=30
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

# Horizontal average
../../scripts/horizontalAverage3.sh $case $startAverageTime

# Graphs of results
ln -sf ../../$time/bw.eps $case/hMeans/$time/bw.eps
ln -sf ../../$time/wb.eps $case/hMeans/$time/wb.eps
../../scripts/graphs.sh $case/hMeans $time TimeMean

