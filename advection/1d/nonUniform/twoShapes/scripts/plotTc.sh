#!/bin/bash -e

# Plot T and Courant number, c, for a specific time

if [ "$#" -ne 2 ]; then
    echo usage 'plotTc.sh case time'
    exit
fi

case=$1
time=$2
shift
shift

writeCellDataxyz -case $case -time $time T > /dev/null
writeCellDataxyz -case $case -time $time Co > /dev/null

awk 'NR == 1 {print $1,$2,$3,4}; NR > 1 {print $0 | "sort -n -k1"}' \
    $case/$time/T.xyz | sponge $case/$time/T.xyz

#sort -n -k 1 $case/$time/T.xyz | sponge $case/$time/T.xyz
sort -n -k 1 $case/$time/Co.xyz | sponge $case/$time/Co.xyz
echo -e "#0.1\n0 0.1\n1 0.1" > $case/constant/C1.xyz

# Files to plot
inputFiles=($case/$time/T.xyz $case/$time/Co.xyz $case/constant/C1.xyz)
outFile=$case/$time/Tc.eps
col=(4 4 2)
colx=1
pens=("0,black" "black,4_4:0" "black,1_1:0")
symbols=("x4p" "p0p" "p0p")
spens=("0,black" "0,white" "0,white")
legends=("@~y@~" "10 c" "c = 1")

#xlabel='x'
xmin=0
xmax=1
dx=0.2
ddx=0
dxg=0
ymin=-0.2
ymax=1.2
dy=0.2
ddy=0
dyg=1
xscale=*1
yscale=("*1" "/10")
legPos=x13/5
projection=X15c/7c
gv=0

. gmtPlot

