#!/bin/bash -e

# Post processing
case=.
startAverageTime=32

# Conditionally and horizontally average into 2
../../scripts/average2.sh $case $startAverageTime

# Graphs of conditionally, horizontally and time averaged results
time=150
../../scripts/graphs2.sh $case/hMeans2 $time timeMean

