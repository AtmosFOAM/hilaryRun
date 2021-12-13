#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log hMeans/[0-9]* hMeans/constant/polyMesh

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Initial buoyancy gradient with perturbation 
setInitialTracerField -name b.air -time 0
setFields -time 0

# Solve Boussinesq equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

# Post processing
startAverageTime=32
writeuvw u

gmtFoam -latestTime  bw
ev */bw.pdf

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
            if [ ${time%.*} -ge ${startAverageTime%.*} ]; then
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
            if [ ${time%.*} -ge ${startAverageTime%.*} ]; then
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

./graphs.sh 152

