#!/bin/bash -e

if [ "$#" -ne 2 ]
then
   echo usage: calcHMean.sh case time
   exit
fi

case=$1
time=$2

# Create P for each part
for part in stable up down; do
    sumFields -case $case $time P.$part $time P $time p.$part
done

# Mutliply fields by sigma
for part in stable up down; do
    for var in b u P; do
        multiplyFields -case $case $time sigma$var.$part $time $var.$part $time sigma.$part
    done
done

# Create horizontalMeans
blockMesh -case $case/hMeans
sed 's/TIME/'$time'/g' $case/hMeans/system/controlDictTIME \
    > $case/hMeans/system/controlDict
mapFields -case $case/hMeans $case -consistent -mapMethod cellVolumeWeight -sourceTime $time

# Divide my sigma
for var in b u P; do
    for part in stable up down; do
        multiplyFields -case $case/hMeans $time $var.$part $time sigma$var.$part $time sigma.$part -pow1 -1
    done
done

# Write xyz cell data
mv $case/hMeans/$time/sigma.sum $case/hMeans/$time/sigma
for part in '' .stable .up .down; do
    for var in b u P sigma massTransfer.stable massTransfer.up massTransfer.down
    do
        if [ -a $case/hMeans/$time/${var}${part} ]; then
            writeCellDataxyz -time $time ${var}${part} -case $case/hMeans
            sort -g -k 3 $case/hMeans/$time/${var}${part}.xyz \
                | sponge $case/hMeans/$time/${var}${part}.xyz
        fi
    done
done

