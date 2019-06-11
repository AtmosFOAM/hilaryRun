#!/bin/bash -e

# Create data files for single column, multi-fluid cases, consistent with
# horizontal means of other cases

if [ "$#" -lt 1 ]
then
   echo usage: ./singleColMultiFluidData.sh caseName [times]
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

echo ./singleColMultiFluidData.sh $case $times

# No horizontal averaging needed, just links
rm -rf $case/hMean
ln -s . $case/hMean

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
    # Write out ascii data and sort by z
    for part in '' .stable .buoyant; do
        for var in b uz Pi sigma massTransfer.buoyant massTransfer.stable; do
            writeCellDataxyz -case $case/hMean -time $time $var$part
            sort -g -k 3 $case/hMean/$time/$var$part.xyz \
                | sponge $case/hMean/$time/$var$part.xyz
        done
    done
    writeCellDataxyz -case $case/hMean -time $time P
    sort -g -k 3 $case/hMean/$time/P.xyz | sponge $case/hMean/$time/P.xyz
    
    # For consistency with single fluid cases, rename Pi.* P.*
    mv $case/$time/Pi.stable.xyz $case/$time/P.stable.xyz
    mv $case/$time/Pi.buoyant.xyz $case/$time/P.buoyant.xyz
done
