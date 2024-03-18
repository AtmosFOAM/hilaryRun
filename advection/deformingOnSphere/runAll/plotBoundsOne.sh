#!/bin/bash -e

# Plot min and max T for every time step for one case

if [ "$#" -ne 1 ]; then
    echo usage 'plotBoundsOne.sh case'
    exit
fi

case=$1

# Assemble bounds for this case
inputFiles=($case/bounds.dat $case/bounds.dat)

echo '#Time min max' > $case/bounds.dat
grep 'T goes' $case/log | awk '{print $1, $5, $7}' >> $case/bounds.dat

outFile=$case/TminMax.eps
col=(3 2)
colx=1
pens=("black" "1,black,4_4:0")
legends=("max"  "min")

#xlabel='time'
ylabel='@~y@~'
xmin=0
xmax=5
dx=1
ddx=0
dxg=0
ymin=-0.2
ymax=1.25
dy=0.2
ddy=0
dyg=1
xscale=*1
yscale=*1
legPos=x0.3/1.3
projection=X15c/8c
gv=0

source gmtPlot

