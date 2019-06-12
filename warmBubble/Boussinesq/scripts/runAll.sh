#!/bin/bash -e
shopt -s extglob

time=1000

# Setup, run and post-process all cases

# Setup and run all cases
#for case in singleFluid/* multiFluid/*; do
for case in multiFluid/*; do
    $case/setup.sh $case
    multiFluidBoussinesqFoam -case $case >& $case/log | cat
done

##exit

## 2D plots for cases with >1 column
#for case in multiFluid/!(singleColumn*); do
#    echo case $case
#    gmtFoam -case $case -time $time b
#    gv $case/$time/b.pdf & 
#done

## Calculate conditional averages and horizontal means for single fluid cases
#for case in singleFluid/*; do
#    if [ -a $case/$time/b ]; then
#        ./scripts/condition.sh $case
#        ./scripts/heatTransport.sh $case
#        ./scripts/plothMeans.sh $case $time
#    fi
#done

# Create horizontal means for single column, multi-fluid cases
for case in multiFluid/singleColumn*; do
    if [ -a $case/$time/b ]; then
        ./scripts/singleColMultiFluidData.sh $case
        ./scripts/heatTransport.sh $case
        ./scripts/plothMeans.sh $case $time
    fi
done

# Create horizontal means for multi-column, multi-fluid cases
for case in multiFluid/!(singleColumn*); do
    echo case $case
    if [ -a $case/$time/b ]; then
        ./scripts/multiColMultiFluidData.sh $case
        ./scripts/heatTransport.sh $case
        ./scripts/plothMeans.sh $case $time
    fi
done

gmtPlot scripts/heatTransportSingleFluid.gmt
gmtPlot scripts/heatTransportMultiFluid.gmt
gmtPlot scripts/heatTransportMultiFluid_colWidth.gmt
gmtPlot scripts/heatTransportMultiFluid_divTransfer.gmt
gmtPlot scripts/heatTransportMultiFluid_Pigamma.gmt

