#!/bin/bash -e
shopt -s extglob

# Setup, run and post-process all cases

# Setup and run all cases
#for case in singleFluid/* multiFluid/*; do
#for case in multiFluid/*; do
#    $case/setup.sh $case
#    multiFluidBoussinesqFoam -case $case >& $case/log &
#done

#exit

# 2D plots for cases with >1 column
#time=1000
#for case in multiFluid/!(singleColumn*); do
#    echo case $case
#    gmtFoam -case $case -time $time b
#    gv $case/$time/b.pdf & 
#done

# Calculate conditional averages and horizontal means for single fluid cases
#time=1000
#for case in singleFluid/*; do
#    if [ -a $case/$time/b ]; then
#        ./scripts/condition.sh $case $time
#    fi
#done

## Create horizontal means for single column, multi-fluid cases
#time=1000
#for case in multiFluid/singleColumn*; do
#    if [ -a $case/$time/b ]; then
#        ./scripts/singleColMultiFluidData.sh $case $time
#    fi
#done

# Create horizontal means for multi-column, multi-fluid cases
#time=1000
#for case in multiFluid/!(singleColumn*); do
#    echo case $case
#    if [ -a $case/$time/b ]; then
#        ./scripts/multiColMultiFluidData.sh $case 1000
#    fi
#done

## Plot horizontal means
#time=1000
#for case in singleFluid/* multiFluid/*; do
#    if [ -a $case/$time/b ]; then
#        ./scripts/plothMeans.sh $case 1000
#    fi
#done

## Calculate heat transport
#for case in singleFluid/*; do
#    ./scripts/condition.sh $case
#    ./scripts/heatTransport.sh $case
#done
gmtPlot scripts/heatTransportSingleFluid.gmt

#for case in multiFluid/!(singleColumn*); do
#    echo case $case
#    ./scripts/multiColMultiFluidData.sh $case
#    ./scripts/heatTransport.sh $case
#done
#for case in multiFluid/singleColumn*; do
#    ./scripts/singleColMultiFluidData.sh $case
#    ./scripts/heatTransport.sh $case
#done
gmtPlot scripts/heatTransportMultiFluid.gmt

