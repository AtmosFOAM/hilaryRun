#!/bin/bash -e

# Create horizontla means for column, multi-fluid cases, consistent with
# horizontal means of other cases

if [ "$#" -lt 1 ]
then
   echo usage: ./multiColMultiFluidData.sh caseName [times]
   exit
fi

case=$1
shift
# Get list of times
times=''
while [ "$#" -ne 0 ]; do
    t=$1
    times="$times $t"
    shift
done
# Otherwise use all times
if [ "$times" == "" ]; then
    for time in `ls -1vd $case/[0-9]*`; do
        t=`filename $time`
        times="$times $t"
    done
fi

echo ./multiColMultiFluidData.sh $case $times

# Horizontal averaging
# setup hMean (horizontal mean) directory
if [[ ! -a $case/hMean ]]; then
    mkdir $case/hMean
    cp -r $case/../../hMean/* $case/hMean
fi
sed 's/TIME/0/g' $case/../../hMean/system/controlDict > $case/hMean/system/controlDict
blockMesh -case $case/hMean

# Write out components of velocity
writeuvw u -case $case
writeuvw u.stable -case $case
writeuvw u.buoyant -case $case

# For consistency with single fluid cases, rename u.stablez uz.stable
for time in $case/[0-9]*; do
    mv $time/u.stablez $time/uz.stable
    mv $time/u.buoyantz $time/uz.buoyant
done

for time in $times; do
    # Multiply fields by sigma (zero or one)
    for part in stable buoyant; do
        for var in b uz p ; do
            multiplyFields -case $case $time sigma$var.$part $time $var.$part \
                 $time sigma.$part
        done
    done

    # Horizontal averages
    sed 's/TIME/'$time'/g' $case/../../hMean/system/controlDict \
        > $case/hMean/system/controlDict
    mapFields -case $case/hMean -mapMethod cellVolumeWeight $case \
              -consistent -noFunctionObjects -sourceTime $time
    # Divide conditional average fields by sigma
    for part in stable buoyant; do
        for var in b uz p ; do
            multiplyFields -case $case/hMean $time $var.$part \
                $time sigma$var.$part $time sigma.$part -pow1 -1
        done
    done
    
    # Write out ascii data and sort by z
    for part in '' .stable .buoyant; do
        for var in b uz p sigma ; do
            if [ -a $case/hMean/$time/$var$part ]; then
                writeCellDataxyz -case $case/hMean -time $time $var$part
                sort -g -k 3 $case/hMean/$time/$var$part.xyz \
                    | sponge $case/hMean/$time/$var$part.xyz
            fi
        done
    done
    writeCellDataxyz -case $case/hMean -time $time P
    sort -g -k 3 $case/hMean/$time/P.xyz | sponge $case/hMean/$time/P.xyz
    
    # Add p to P for plotting
    paste $case/hMean/$time/p.stable.xyz $case/hMean/$time/P.xyz | \
        awk '{print $1, $2, $3, $4+$8}' > $case/hMean/$time/P.stable.xyz
    paste $case/hMean/$time/p.buoyant.xyz $case/hMean/$time/P.xyz | \
        awk '{print $1, $2, $3, $4+$8}' > $case/hMean/$time/P.buoyant.xyz
done
