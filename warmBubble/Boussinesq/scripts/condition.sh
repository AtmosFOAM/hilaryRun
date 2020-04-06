#!/bin/bash -e

# Conditional and horizontal averaging for single fluid cases either for all
# times a list of specific times

if [ "$#" -lt 1 ]
then
   echo usage: ./condition.sh caseName [times]
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

echo ./condition.sh $case $times

# setup hMean (horizontal mean) directory
if [[ ! -a $case/hMean ]]; then
    mkdir $case/hMean
    cp -r $case/../../hMean/* $case/hMean
fi
sed 's/TIME/0/g' $case/../../hMean/system/controlDict > $case/hMean/system/controlDict
blockMesh -case $case/hMean

# Write out components of velocity
for time in $times; do
    writeuvw u -case $case -time $time
done

# Conditional averaging 
for time in $times; do
    # based on w for time!=0
    if [ $time != "0" ]; then
        # Redefine sigma based on w
        conditionalAverage -case $case -time $time uz 0 stable buoyant
#        topoSet -case $case -dict system/conditionalSamplingDict -time $time
#        setFields -case $case -dict system/conditionalSamplingDict \
#            -time $time -noFunctionObjects

#    # Based on b for time=0
#    else
#        topoSet -case $case -dict system/conditionalSamplingDictb -time $time
#        setFields -case $case -dict system/conditionalSamplingDict \
#            -time $time -noFunctionObjects
    fi

    # Multiply fields by sigma (zero or one)
    for part in stable buoyant; do
        for var in b uz P; do
            multiplyFields -case $case $time sigma$var.$part $time $var \
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
        for var in b uz P; do
            multiplyFields -case $case/hMean $time $var.$part \
                $time sigma$var.$part $time sigma.$part -pow1 -1
        done
    done
    
    # Calculate pressure gradients
    #postProcess  -time $time -case $case/hMean -fields "(P.stable P.buoyant)"
    
    # Write out ascii data and sort by z
    for part in '' .stable .buoyant; do
        for var in b uz P sigma sigmab sigmaP sigmauz; do
            if [ -a $case/hMean/$time/$var$part ]; then
                writeCellDataxyz -case $case/hMean -time $time $var$part
                sort -g -k 3 $case/hMean/$time/$var$part.xyz \
                    | sponge $case/hMean/$time/$var$part.xyz
            fi
        done
    done
    # Calculate pressure difference from the mean
    for part in stable buoyant; do
        paste $case/hMean/$time/P.$part.xyz $case/hMean/$time/P.xyz | \
            awk '{print $1, $2, $3, $4-$8}' > $case/hMean/$time/Pi.$part.xyz
    done

done

