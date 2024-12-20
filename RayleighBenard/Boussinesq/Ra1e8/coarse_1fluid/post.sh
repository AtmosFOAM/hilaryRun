#!/bin/bash -e

# Post processing
startAverageTime=32
writeuvw u

gmtFoam -latestTime $time ub
ev */ub.pdf

# Start conditional averaging
BoussinesqNusselt.sh $case 0 $startAverageTime
meanHeatTransfer=`awk 'END {print $5}' $case/globalSumheatTransferzTimeMean.dat`
conditionalAverage3 -case $case -time $startAverageTime':' stable up down heatTransferz \
    $meanHeatTransfer uz 0

# Conditionally average b, P and u and horizontally average
# Multiply by sigma
for var in P b u; do
    for part in stable up down; do
        for time in [0-9]*; do
            if [ $time -ge $startAverageTime ]; then
                echo $time sigma$var.$part $time $var $time sigma.$part
                multiplyFields $time sigma$var.$part $time $var $time sigma.$part
            fi
        done
    done
done

# Horizontally average
blockMesh -case hMeans
mapFieldsSerial -case hMeans . -consistent -mapMethod cellVolumeWeight \
    -time $startAverageTime':'

# Divide by sigma
for var in P b u; do
    for part in stable up down; do
        for time in [0-9]*; do
            if [ $time -ge $startAverageTime ]; then
                multiplyFields -case hMeans $time $var.$part $time \
                    sigma$var.$part $time sigma.$part -pow1 -1
            fi
        done
    done
done

# Time averages
for part in stable up down; do
    for var in sigma P b u; do
        timeMean -case hMeans -time $startAverageTime':' ${var}.${part}
    done
done
timeMean -case hMeans -time $startAverageTime':' heatTransferz

./graphs.sh 152

