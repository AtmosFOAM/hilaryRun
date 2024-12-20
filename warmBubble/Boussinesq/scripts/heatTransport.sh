#!/bin/bash -e

# Calculate the heat transport as integral(b z)dV of the horizontal means

if [ "$#" -lt 1 ]
then
   echo usage: ./heatTransport.sh caseName [times]
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

echo heatTransport.sh $case $times

# First calculate field z to multiply b
cp $case/../../hMean/system/z_tracerFieldDict $case/hMean/system
cp $case/../../hMean/constant/z_init $case/hMean/constant
setAnalyticTracerField -case $case/hMean -time $time -name z \
    -tracerDict z_tracerFieldDict
#mv $case/hMean/[0-9]*/z $case/hMean/constant
rm $case/hMean/*/zf_analytic

# Create bz for all times and volume average
for time in $times; do
    multiplyFields -case $case/hMean $time bz $time b constant z
done
globalSum -case $case/hMean bz
globalSum -case $case/hMean b
paste $case/hMean/globalSumbz.dat $case/hMean/globalSumb.dat \
    | awk '{if ($10*1==$10) print $1, $2/$10'} > $case/hMean/globalSumZmean.dat

