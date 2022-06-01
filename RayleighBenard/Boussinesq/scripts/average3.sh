#!/bin/bash -e

# Conditionally and horizontally average into 3 domains

if [ "$#" -ne 2 ]
then
   echo usage: average3.sh case startAveraging
   exit
fi

case=$1
startAveraging=$2 

# Get mean heat transfer for the condition and apply
meanHeatTransfer=`awk 'END {print $5}' $case/globalSumheatTransferzTimeMean.dat`
writeuvw u -case $case
conditionalAverage3 -case $case -time $startAveraging':' stable up down \
    heatTransferz $meanHeatTransfer uz 0

# Conditionally average b, P and u and KE and horizontally average
# Multiply by sigma
for var in P b u KE; do
    for part in stable up down; do
        for time in $case/[0-9]*; do
        t=`filename $time`
            if [ $t -ge $startAveraging ]; then
                echo $t sigma$var.$part $t $var $t sigma.$part
                multiplyFields -case $case $t sigma$var.$part \
                        $t $var $t sigma.$part
            fi
        done
    done
done

# Horizontally average
blockMesh -case $case/hMeans
nCells1=`checkMesh -case $case | grep cells | head -1 | awk '{print $2}'`
nCellsh=`checkMesh -case $case/hMeans | grep cells | head -1 | awk '{print $2}'`
cellRatio=`echo $nCells1 $nCellsh | awk '{print $1/$2}'`

horizontalMean -case $case -time $startAveraging':' $case/hMeans $cellRatio \
    '(sigma.stable sigma.up sigma.down
      sigmab.stable sigmab.up sigmab.down
      sigmau.stable sigmau.up sigmau.down
      sigmaP.stable sigmaP.up sigmaP.down
      sigmaKE.stable sigmaKE.up sigmaKE.down
      KE heatTransferz)'

# Divide by sigma
for var in P b u KE; do
    for part in stable up down; do
        for time in $case/hMeans/[0-9]*; do
            t=`filename $time`
            if [ $t -ge $startAveraging ]; then
                multiplyFields -case $case/hMeans $t $var.$part $t \
                    sigma$var.$part $t sigma.$part -pow1 -1
            fi
        done
    done
done

# Time averages
for part in stable up down; do
    for var in sigma P b u KE; do
        timeMean -case $case/hMeans -time $startAveraging':' ${var}.${part}
    done
done
timeMean -case $case/hMeans -time $startAveraging':' heatTransferz
timeMean -case $case/hMeans -time $startAveraging':' KE
