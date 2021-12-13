#!/bin/bash -e

time=$1
case=.

# Post processing

# Simple Plots of fields
#time=150
gmtFoam -time $time up
gmtFoam -time $time down
gmtFoam -time $time stable
gmtFoam -time $time ub
ev $time/*pdf
sumFields $time sigmaDiff $time sigma.up $time sigma.down -scale1 -1
gmtFoam -time $time uSigma
ev $time/uSigma.pdf

# Calculate heat transfer throughout domain
startAverageTime=30
BoussinesqNusselt.sh . 0 $startAverageTime

# To start horizontally averaging, multiply by sigma
for time in [0-9]*; do
    for var in p b u; do for part in stable up down; do
        if [ $time -ge $startAverageTime ]; then
            echo $time sigma$var.$part $time $var $time sigma.$part
            multiplyFields $time sigma$var.$part $time $var.$part $time sigma.$part
        fi
    done; done
done

# Horizontally average
blockMesh -case hMeans
horizontalMean -case . -time $startAverageTime':' hMeans 10 \
    '(sigma.stable sigma.up sigma.down
      sigmau.stable sigmau.up sigmau.down
      sigmap.stable sigmap.up sigmap.down
      sigmab.stable sigmab.up sigmab.down
      heatTransferz P)'
#mapFieldsSerial -case hMeans . -consistent -mapMethod cellVolumeWeight \
#    -time $startAverageTime':'

# Divide horizontally averaged fields by sigma
for time in [0-9]*; do
    for var in p b u; do for part in stable up down; do
        if [ $time -ge $startAverageTime ]; then
            multiplyFields -case hMeans $time $var.$part $time \
                sigma$var.$part $time sigma.$part -pow1 -1
        fi
    done; done
done

# Time averages
for part in stable up down; do for var in sigma p b u; do
    timeMean -case hMeans -time $startAverageTime':' ${var}.${part}
done; done
timeMean -case hMeans -time $startAverageTime':' heatTransferz
timeMean -case hMeans -time $startAverageTime':' P

time=$1
for part in stable up down; do
    sumFields -case hMeans $time P.$part $time P $time p.$part
    sumFields -case hMeans $time P.${part}TimeMean $time PTimeMean $time p.${part}TimeMean
done

./graphs.sh $time

