#!/bin/bash -e

# Conditionally average the 3 fluids

time=$1
case=.
startAverageTime=30

writeuvw -case $case -time $startAverageTime: u
meanHeatTransfer=`awk 'END {print $5}' $case/globalSumheatTransferzTimeMean.dat`
conditionalAverage3 -case $case -time $startAverageTime: Stable Up Down \
    heatTransferz $meanHeatTransfer uz 0

# To start horizontally averaging, multiply by Sigma
for time in [0-9]*; do
    for var in P b u; do for part in Stable Up Down; do
        if [ $time -ge $startAverageTime ]; then
            echo $time sigma$var.$part $time $var $time sigma.$part
            multiplyFields $time sigma$var.$part $time $var $time sigma.$part
        fi
    done; done
done

# Horizontally average
blockMesh -case hMeans
horizontalMean -case . -time $startAverageTime':' hMeans 10 \
    '(sigma.Stable sigma.Up sigma.Down
      sigmau.Stable sigmau.Up sigmau.Down
      sigmaP.Stable sigmaP.Up sigmaP.Down
      sigmab.Stable sigmab.Up sigmab.Down
      heatTransferz P)'
#mapFieldsSerial -case hMeans . -consistent -mapMethod cellVolumeWeight \
#    -time $startAverageTime':'

# Divide horizontally averaged fields by sigma
for time in [0-9]*; do
    for var in P b u; do for part in Stable Up Down; do
        if [ $time -ge $startAverageTime ]; then
            multiplyFields -case hMeans $time $var.$part $time \
                sigma$var.$part $time sigma.$part -pow1 -1
        fi
    done; done
done

# Time averages
for part in Stable Up Down; do for var in sigma P b u; do
    timeMean -case hMeans -time $startAverageTime':' ${var}.${part}
done; done

./graphs3.sh $time

