#!/bin/bash -e

# Conditionally and horizontally average into 3 domains

if [ "$#" -ne 2 ]
then
   echo usage: horizontalAverage3.sh case startAveraging
   exit
fi

case=$1
startAveraging=$2

# Create P for each fluid
for part in stable up down; do
    for time in $case/[0-9]*; do
        t=`filename $time`
        sumFields -case $case $t P.$part $t P $t p.$part
    done
done


# Multiply by sigma
for var in P b u KE TKE; do
    for part in stable up down; do
        for time in $case/[0-9]*; do
            t=`filename $time`
            if [ $t -ge $startAveraging ]; then
                echo $t sigma$var.$part $t $var $t sigma.$part
                multiplyFields -case $case $t sigma$var.$part \
                        $t $var.$part $t sigma.$part
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
      sigmab.stable sigmab.up sigmab.down b
      sigmau.stable sigmau.up sigmau.down
      sigmaP.stable sigmaP.up sigmaP.down
      sigmaKE.stable sigmaKE.up sigmaKE.down KE
      sigmaTKE.stable sigmaTKE.up sigmaTKE.down TKE
      heatTransfer.stable heatTransfer.up heatTransfer.down
      heatTransfer)'

# Time averages
for part in .stable .up .down; do
    for var in sigma heatTransfer; do
        timeMean -case $case/hMeans -time $startAveraging':' ${var}${part}
    done
    for var in P b u KE TKE; do
        timeMean -case $case/hMeans -time $startAveraging':' sigma${var}${part}
    done
done
for var in b KE TKE heatTransfer; do
    timeMean -case $case/hMeans -time $startAveraging':' $var
done

# Divide by sigma
for var in P b u KE TKE; do
    for part in stable up down; do
        for time in $case/hMeans/[0-9]*; do
            t=`filename $time`
            if [ $t -ge $startAveraging ]; then
                multiplyFields -case $case/hMeans $t $var.${part} $t \
                    sigma$var.$part $t sigma.$part -pow1 -1
                multiplyFields -case $case/hMeans $t $var.${part}TimeMean $t \
                    sigma$var.${part}TimeMean $t sigma.${part}TimeMean -pow1 -1
            fi
        done
    done
done

# Add TKE and KE
for time in $case/hMeans/[0-9]*; do
    t=`filename $time`
    if [ $t -ge $startAveraging ]; then
        sumFields -case $case/hMeans $t totalKE $t KE $t TKE
        sumFields -case $case/hMeans $t totalKETimeMean \
                 $t KETimeMean $t TKETimeMean
        for part in .stable .up .down; do
            sumFields -case $case/hMeans $t totalKE${part} $t sigmaKE${part} \
                      $t sigmaTKE${part}
            sumFields -case $case/hMeans $t totalKE${part}TimeMean \
                     $t sigmaKE${part}TimeMean $t sigmaTKE${part}TimeMean
        done
    fi
done

rm $case/*/sigma?*.* $case/hMeans/*/sigma?*.*

