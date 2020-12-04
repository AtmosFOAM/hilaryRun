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

# For consistency with single fluid cases, rename u.stablez uz.stable
for time in $times; do
# Write out components of velocity
    writeuvw u -case $case -time $time
    writeuvw u.stable -case $case -time $time
    writeuvw u.buoyant -case $case -time $time
    mv $time/u.stablez $time/uz.stable
    mv $time/u.buoyantz $time/uz.buoyant
done

for time in $times; do
    # Write out ascii data and sort by z
    for part in '' .stable .buoyant; do
        for var in b uz p sigma massTransfer.buoyant massTransfer.stable; do
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
