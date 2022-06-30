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
for var in P b u KE heatTransfer; do
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
      sigmaKE.stable sigmaKE.up sigmaKE.down KE
      sigmaheatTransfer.stable sigmaheatTransfer.up sigmaheatTransfer.down
      heatTransfer)'

# Time averages
for part in .stable .up .down; do
    for var in sigma heatTransfer; do
        timeMean -case $case/hMeans -time $startAveraging':' ${var}${part}
    done
    for var in P b u KE heatTransfer; do
        timeMean -case $case/hMeans -time $startAveraging':' sigma${var}${part}
    done
done
timeMean -case $case/hMeans -time $startAveraging':' heatTransfer
timeMean -case $case/hMeans -time $startAveraging':' KE

# Divide by sigma
for part in stable up down; do
    for time in $case/hMeans/[0-9]*; do
        t=`filename $time`
        if [ $t -ge $startAveraging ]; then
            for var in P b u KE; do
                multiplyFields -case $case/hMeans $t $var.${part} $t \
                    sigma$var.$part $t sigma.$part -pow1 -1
                multiplyFields -case $case/hMeans $t $var.${part}TimeMean $t \
                    sigma$var.${part}TimeMean $t sigma.${part}TimeMean -pow1 -1
            done
            mv $case/hMeans/$t/sigmaheatTransfer.$part \
               $case/hMeans/$t/heatTransfer.$part
            mv $case/hMeans/$t/sigmaheatTransfer.${part}TimeMean \
               $case/hMeans/$t/heatTransfer.${part}TimeMean
        fi
    done
done

# Make KE into totalKE then calculate new resolved KE and hence TKE
for time in $case/hMeans/[0-9]*; do
    t=`filename $time`
    if [ $t -ge $startAveraging ]; then
        for part in '' .stable .up .down; do
            cp $case/hMeans/$t/KE${part} $case/hMeans/$t/totalKE${part}save
            cp $case/hMeans/$t/KE${part}TimeMean \
               $case/hMeans/$t/totalKE${part}TimeMeansave
        done
        $case/../../scripts/KEoneTime.sh $case/hMeans $t 'stable up down'
        $case/../../scripts/KEtimeMean.sh $case/hMeans $t 'stable up down'
        for part in '' .stable .up .down; do
            mv $case/hMeans/$t/totalKE${part}save $case/hMeans/$t/totalKE${part}
            mv $case/hMeans/$t/totalKE${part}TimeMeansave \
               $case/hMeans/$t/totalKE${part}TimeMean
            sumFields -case $case/hMeans $t TKE${part} \
                $t totalKE${part} $t KE${part} -scale1 -1
            sumFields -case $case/hMeans $t TKE${part}TimeMean \
                $t totalKE${part}TimeMean $t KE${part}TimeMean -scale1 -1
        done
    fi
done

rm -f $case/*/sigma?*.* $case/hMeans/*/sigma?*.*

