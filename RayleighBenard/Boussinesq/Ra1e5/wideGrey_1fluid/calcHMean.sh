#!/bin/bash -e

if [ "$#" -ne 2 ]
then
   echo usage: calcHMean.sh case time
   exit
fi

case=$1
time=$2

# Create horizontalMeans
blockMesh -case $case/hMeans
sed 's/TIME/'$time'/g' $case/hMeans/system/controlDictTIME \
    > $case/hMeans/system/controlDict
mapFields -case $case/hMeans $case -consistent -mapMethod cellVolumeWeight -sourceTime $time

# Write xyz cell data
for var in b u P; do
    writeCellDataxyz -case $case/hMeans -time $time $var
    sort -g -k 3 $case/hMeans/$time/$var.xyz \
        | sponge $case/hMeans/$time/$var.xyz
done

