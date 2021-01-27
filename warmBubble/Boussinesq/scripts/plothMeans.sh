#!/bin/bash -e

# Plot horizontal means for a given case and time

if [ "$#" -lt 1 ]
then
   echo usage: ./plothMeans.sh caseName [times]
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

echo ./plothMeans.sh $case $times

# Split case name into two parts
case1=`echo $case | awk -F'/' '{print $1}'`
case2=`echo $case | awk -F'/' '{print $2}'`

if [ "$case2" == "" ]; then case2=.; fi

# Check that scripts exists
if [ ! -d $case/scripts ]; then
    ln -sf ../../scripts $case/scripts
fi

vars="sigma sigmaCompare b bCompare w wCompare P Pcompare"
# Plot horizontal means of b, P, sigma and w
for time in $times; do
    for var in $vars; do
        sed 's/TIME/'$time'/g' $case/scripts/$var.gmt \
            | sed 's/DIR/'$case1'/g' \
            | sed 's/CASE/'$case2'/g' > $case/scripts/tmp.gmt
        gmtPlot $case/scripts/tmp.gmt
    done
    montage $case/hMean/$time/sigmaCompare.eps $case/hMean/$time/bCompare.eps \
            $case/hMean/$time/wCompare.eps $case/hMean/$time/Pcompare.eps \
            -tile 4x1 -geometry +0+0 $case/hMean/$time/results.png
    display $case/hMean/$time/results.png &
done
rm $case/scripts/tmp.gmt

