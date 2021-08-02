#!/bin/bash -e

if [ "$#" -ne 2 ]
then
   echo usage: graphData.sh case time
   exit
fi

case=$1
time=$2

#rm -rf $case/hMeans/constant hMeans/$time
#sed 's/TIME/0/g' $case/hMeans/system/controlDictTIME \
#    > $case/hMeans/system/controlDict
#blockMesh -case $case/hMeans

## Make sigmas closer to 1 or zero
#topoSet -time $time -case $case -dict system/topoSetDict
#for newPart in Stable Up Down; do
#    cp $time/sigma.sum $time/sigma.$newPart
#done
#setFields -time $time -case $case -dict system/setFieldsDict2

# Mutliply fields by sigma
#for part in Stable Up Down; do
for part in stable up down; do
    for var in b u P; do
        multiplyFields -case $case $time sigma$var.$part $time $var $time sigma.$part
    done
done

# Create horizontalMeans
sed 's/TIME/'$time'/g' $case/hMeans/system/controlDictTIME \
    > $case/hMeans/system/controlDict
mapFields -case $case/hMeans $case -consistent -mapMethod cellVolumeWeight -sourceTime $time

# Divide my sigma
for var in b u P; do
#    for part in Stable Up Down; do
    for part in stable up down; do
        multiplyFields -case $case/hMeans $time $var.$part $time sigma$var.$part $time sigma.$part -pow1 -1
    done
done

# Write xyz cell data
mv $case/hMeans/$time/sigma.sum $case/hMeans/$time/sigma
for var in b u P; do
    writeCellDataxyz -case $case -time $time $var
done
#for part in '' .Stable .Up .Down; do
for part in '' .stable .up .down; do
    for var in b u P sigma; do
        writeCellDataxyz -time $time ${var}${part} -case $case/hMeans
        sort -g -k 3 $case/hMeans/$time/${var}${part}.xyz \
            | sponge $case/hMeans/$time/${var}${part}.xyz
    done
done

