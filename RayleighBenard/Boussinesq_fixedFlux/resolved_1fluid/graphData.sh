#!/bin/bash -e

if [ "$#" -ne 2 ]
then
   echo usage: graphData.sh case time
   exit
fi

case=$1
time=$2

#rm -rf hMeans/constant hMeans/$time
#sed 's/TIME/0/g' hMeans/system/controlDictTIME \
#    > hMeans/system/controlDict
#blockMesh -case hMeans

# Conditional average based on w
writeuvw -case $case -time $time u
conditionalAverage -case $case uz 0 down up -time $time
for var in b u P; do
    for part in down up; do
        multiplyFields -case $case $time sigma$var.$part $time $var $time sigma.$part
    done
done

# Create horizontalMeans
sed 's/TIME/'$time'/g' $case/hMeans/system/controlDictTIME \
    > $case/hMeans/system/controlDict
mapFields -case $case/hMeans $case -consistent -mapMethod cellVolumeWeight -sourceTime $time

# Divide my sigma
for var in b u P; do
    for part in down up; do
        multiplyFields -case $case/hMeans $time $var.$part $time sigma$var.$part $time sigma.$part -pow1 -1
    done
done

# Write xyz cell data
for var in b u P sigma.down sigma.up b.down b.up u.down u.up P.down P.up ; do
    writeCellDataxyz -case $case -time $time $var
done
for var in b u P sigma.down sigma.up b.down b.up u.down u.up P.down P.up ; do
    writeCellDataxyz -time $time $var -case $case/hMeans
    sort -g -k 3 $case/hMeans/$time/$var.xyz | sponge $case/hMeans/$time/$var.xyz
done

