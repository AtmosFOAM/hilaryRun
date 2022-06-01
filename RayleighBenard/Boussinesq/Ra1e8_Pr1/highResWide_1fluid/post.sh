#!/bin/bash -e

# Post processing
case=.
startAverageTime=32

#writeuvw u

gmtFoam -latestTime ub
ev `ls -rt */ub.pdf | tail -1`

# Scatter plot of results
time=150
../../scripts/scatter.sh $case $time

# Calculate Nusselt number and KE
../../scripts/Nusselt.sh $case 0 $startAverageTime
../../scripts/KE.sh $case 0 $startAverageTime air

# Conditionally and horizontally average into 3
../../scripts/average3.sh $case $startAverageTime

# Graphs of conditionally, horizontally and time averaged results
../../scripts/graphs.sh $case/hMeans 150 timeMean

