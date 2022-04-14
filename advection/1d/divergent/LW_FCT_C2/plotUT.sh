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

writeuvw -case $case -time 0 U > /dev/null
writeCellDataxyz -case $case -time 0 Ux > /dev/null
writeCellDataxyz -case $case -time $time T > /dev/null
writeCellDataxyz -case $case -time $time Co > /dev/null
sort -n -k 1 $case/0/Ux.xyz | sponge $case/0/Ux.xyz
sort -n -k 1 $case/$time/T.xyz | sponge $case/$time/T.xyz
sort -n -k 1 $case/$time/Co.xyz | sponge $case/$time/Co.xyz
echo -e '#ones\n0 1\n1 1' > constant/one.dat

# Files to plot
inputFiles=($case/0/Ux.xyz $case/$time/T.xyz $case/$time/Co.xyz constant/one.dat)
outFile=$case/$time/UT.eps
col=(4 4 4 2)
colx=1
pens=("blue" "black" "red" "red,1_2:0")
legends=("u"  "@~y@~" "c")

#xlabel='x'
xmin=0
xmax=1
dx=0.2
ddx=0
dxg=0
ymin=0
ymax=5
dy=1
ddy=0
dyg=0
xscale=*1
yscale=*1
legPos=x8/5
projection=X10c/7c
gv=0

. gmtPlot

