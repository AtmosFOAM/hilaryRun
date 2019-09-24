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
    # Multiply by sigma
    for var in Pi b uz; do for part in stable buoyant; do
        multiplyFields -case $case/hMean $time sigma$var.$part $time $var.$part \
            $time sigma.$part
    done; done

    # Write out ascii data and sort by z
    for part in '' .stable .buoyant; do
        for var in b uz Pi sigma sigmab sigmaPi sigmauz massTransfer.buoyant massTransfer.stable dPdz; do
            if [ -a $case/hMean/$time/$var$part ]; then
                writeCellDataxyz -case $case/hMean -time $time $var$part
                sort -g -k 3 $case/hMean/$time/$var$part.xyz \
                    | sponge $case/hMean/$time/$var$part.xyz
            fi
        done
    done
    writeCellDataxyz -case $case/hMean -time $time P
    sort -g -k 3 $case/hMean/$time/P.xyz | sponge $case/hMean/$time/P.xyz
    
    # For consistency with single fluid cases, rename Pi.* P.*
    mv $case/$time/sigmaPi.stable.xyz $case/$time/sigmaP.stable.xyz
    mv $case/$time/sigmaPi.buoyant.xyz $case/$time/sigmaP.buoyant.xyz
    
    # Add Pi to P for plotting
    paste $case/hMean/$time/Pi.stable.xyz $case/hMean/$time/P.xyz | \
        awk '{print $1, $2, $3, $4+$8}' > $case/hMean/$time/P.stable.xyz
    paste $case/hMean/$time/Pi.buoyant.xyz $case/hMean/$time/P.xyz | \
        awk '{print $1, $2, $3, $4+$8}' > $case/hMean/$time/P.buoyant.xyz
done
