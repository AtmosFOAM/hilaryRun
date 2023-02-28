#!/bin/bash -e

# Plot T for a specific time and compare with time zero

if [ "$#" -ne 2 ]; then
    echo usage 'plotTc01.sh case time'
    exit
fi

case=$1
time0=0
time1=$2
shift

writeCellDataxyz -case $case -time $time0 T > /dev/null
writeCellDataxyz -case $case -time $time1 T > /dev/null

for file in $case/$time0/T.xyz $case/$time1/T.xyz ; do
    awk 'NR == 1 {print $0}; NR > 1 {print $0 | "sort -n -k1"}' \
        $file | sponge $file
done

# Files to plot
inputFiles=($case/$time0/T.xyz $case/$time1/T.xyz)
outFile=$case/$time1/T.eps
col=(4 4)
colx=1
pens=("black" "black,5_5:0")
symbols=("p0p" "x4p")
spens=("0,white" "1,black")
legends=("@~y@~@-0@-" "@~y@~@-1@-")

#xlabel='x'
xmin=0
xmax=1
dx=0.2
ddx=0
dxg=0
ymin=0
ymax=1
dy=0.2
ddy=0
dyg=1
xscale=*1
yscale=("*1" "*1")
legPos=x13/4
projection=X15c/7c
gv=0

. gmtPlot

