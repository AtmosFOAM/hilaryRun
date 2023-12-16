#!/bin/bash -e

# Plot T and Courant number, c, for a specific time

if [ "$#" -ne 2 ]; then
    echo usage 'plotT.sh case time'
    exit
fi

case=$1
time=$2
shift
shift

writeCellDataxyz -case $case -time $time T > /dev/null

awk 'NR == 1 {print $1,$2,$3,4}; NR > 1 {print $0 | "sort -n -k1"}' \
    $case/$time/T.xyz | sponge $case/$time/T.xyz


# Files to plot
inputFiles=($case/$time/T.xyz)
outFile=$case/$time/T.eps
col=(4)
colx=1
pens=("1,black")

#xlabel='x'
xmin=0
xmax=1
dx=0.2
ddx=0
dxg=0
ymin=-1
ymax=1
dy=0.5
ddy=0
dyg=1
xscale=*1
yscale=("*1")
legPos=x13/5
projection=X15c/10c
gv=0

. gmtPlot
rm $case/$time/T.xyz
