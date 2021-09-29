#!/bin/bash -e

# Plot U and T for a specific time

if [ "$#" -ne 2 ]; then
    echo usage 'plotUT.sh case time'
    exit
fi

case=$1
time=$2
shift
shift

writeCellDataxyz -case $case -time 0 Ux > /dev/null
writeCellDataxyz -case $case -time 0 T > /dev/null
writeCellDataxyz -case $case -time $time T > /dev/null
sort -n -k 1 $case/0/Ux.xyz | sponge $case/0/Ux.xyz
sort -n -k 1 $case/0/T.xyz | sponge $case/0/T.xyz
sort -n -k 1 $case/$time/T.xyz | sponge $case/$time/T.xyz

# Files to plot
inputFiles=($case/0/Ux.xyz $case/0/T.xyz $case/$time/T.xyz)
outFile=$case/$time/UT.eps
col=4
colx=1
pens=("blue" "black" "black,6_4:0")
legends=("u"  "@~Y@~@-0@-" "@~Y@~")

#xlabel='x'
xmin=0
xmax=1
dx=0.2
ddx=0
dxg=0
ymin=0
ymax=1.6
dy=0.5
ddy=0
dyg=0
xscale=*1
yscale=*1
legPos=x8/5
projection=X10c/7c
gv=1

. gmtPlot

