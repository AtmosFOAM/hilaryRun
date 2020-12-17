#!/bin/bash -e
shopt -s extglob

if [ "$#" -ne 1 ]
then
   echo usage: ./runSingleColumnTwoFluid.sh caseName
   exit
fi

case=$1


# Setup and run

#$case/setup.sh $case
#multiFluidBoussinesqFoam -case $case >& $case/log

# Plots
for time in 500 1000; do
    ./scripts/singleColMultiFluidData.sh $case $time
    ./scripts/plothMeans.sh $case $time
done

./scripts/singleColMultiFluidData.sh $case
./scripts/heatTransport.sh $case
mkdir -p plots
gmtPlot scripts/heatTransport.gmt

./scripts/plothMeans.sh $case
gmtFoam -case $case bU

