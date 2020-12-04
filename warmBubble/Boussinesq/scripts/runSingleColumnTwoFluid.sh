#!/bin/bash -e
shopt -s extglob

if [ "$#" -ne 1 ]
then
   echo usage: ./runOne.sh caseName
   exit
fi

case=$1


# Setup and run

#$case/setup.sh $case
multiFluidBoussinesqFoam -case $case >& $case/log

# Plots
for time in 500 1000; do
    ./scripts/singleColMultiFluidData.sh $case $time
    ./scripts/plothMeans.sh $case $time
done

./scripts/heatTransport.sh $case
mkdir -p plots
gmtPlot scripts/heatTransport.gmt

time=1000
var=Pi
sed 's/TIME/'$time'/g' scripts/$var.gmt \
            | sed 's/CASE/'$case'/g' > scripts/tmp.gmt
gmtPlot scripts/tmp.gmt


