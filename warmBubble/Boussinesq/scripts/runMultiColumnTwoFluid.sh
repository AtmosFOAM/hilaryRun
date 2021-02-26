#!/bin/bash -e
shopt -s extglob

if [ "$#" -ne 1 ]
then
   echo usage: ./runMultiColumnTwoFluid.sh caseName
   exit
fi

case=$1


# Setup and run

#$case/setup.sh $case
#multiFluidBoussinesqFoam -case $case >& $case/log

# Plots
./scripts/multiColMultiFluidData.sh $case 500 1000
./scripts/plothMeans.sh $case 500 1000

./scripts/multiColMultiFluidData.sh $case
./scripts/heatTransport.sh $case
mkdir -p plots
gmtPlot scripts/heatTransport.gmt

gmtFoam bUcoarse
eps2gif bUcoarse.gif 0/bUcoarse.pdf ???/bUcoarse.pdf ????/bUcoarse.pdf

#mkdir -p $case/animategraphics
#t=0
#time=0
#while [ "$time" -le 1000 ]; do
#    montage $case/$time/bUsigma.pdf $case/hMean/$time/b.eps \
#            $case/hMean/$time/sigma.eps \
#            -tile 3x1 -geometry +0+0 $case/animategraphics/results_$t.png
#    display $case/animategraphics/results_$t.png &
#    let t=$t+1
#    let time=$time+100
#done

