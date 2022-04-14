#!/bin/bash -e

# Plot T and Courant number, c, for a specific time

if [ "$#" -ne 1 ]; then
    echo usage 'plotTc01.sh case'
    exit
fi

case=$1
time0=0
time1=1
shift

writeCellDataxyz -case $case -time $time0 T > /dev/null
writeCellDataxyz -case $case -time $time1 T > /dev/null
writeCellDataxyz -case $case -time $time0 Co > /dev/null

for file in $case/$time0/T.xyz $case/$time1/T.xyz $case/$time0/Co.xyz; do
    awk 'NR == 1 {print $0}; NR > 1 {print $0 | "sort -n -k1"}' \
        $file | sponge $file
done
echo -e "#0.1\n0 0.1\n1 0.1" > $case/constant/C1.xyz

# Files to plot
inputFiles=($case/$time0/T.xyz $case/$time1/T.xyz 
            $case/$time0/Co.xyz $case/constant/C1.xyz)
outFile=$case/$time1/Tc01.eps
col=(4 4 4 2)
colx=1
pens=("black" "black" "1,black,4_2:0" "black,1_2:0")
symbols=("p0p" "x4p" "p0p" "p0p")
spens=("0,white" "0,black" "0,white" "0,white")
legends=("@~y@~@-0@-" "@~y@~@-1@-" "10 c" "c = 1")

#xlabel='x'
xmin=0
xmax=1
dx=0.2
ddx=0
dxg=0
ymin=-0.1
ymax=1.1
dy=0.2
ddy=0
dyg=1
xscale=*1
yscale=("*1" "*1" "/10" "*1" )
legPos=x13/4
projection=X15c/7c
gv=0

. gmtPlot

