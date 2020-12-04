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
if [ ! -d scripts ]; then
    ln -sf ../../scripts
fi

vars="sigma sigmaCompare b bCompare w wCompare P Pcompare S"
# Plot horizontal means of b, P, sigma and w
for time in $times; do
    for var in $vars; do
        sed 's/TIME/'$time'/g' scripts/$var.gmt \
            | sed 's/DIR/'$case1'/g' \
            | sed 's/CASE/'$case2'/g' > scripts/tmp.gmt
        gmtPlot scripts/tmp.gmt
    done
    montage $time/sigmaCompare.eps $time/bCompare.eps $time/wCompare.eps \
            $time/Pcompare.eps $time/S.eps -tile 5x1 -geometry +0+0 $time/results.png
    eog $time/results.png &
done
rm scripts/tmp.gmt

