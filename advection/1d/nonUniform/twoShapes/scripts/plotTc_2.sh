#!/bin/bash -e

# Plot T and Courant number, c, for a specific time comparing uniform and 
# non-uniform grids

if [ "$#" -ne 2 ]; then
    echo usage 'plotTc_2.sh caseUniform caseNonu'
    exit
fi

caseUniform=$1
caseNonu=$2
time0=0
time1=1
shift
shift

writeCellDataxyz -case $caseUniform -time $time0 T > /dev/null
writeCellDataxyz -case $caseUniform -time $time1 T > /dev/null
writeCellDataxyz -case $caseNonu -time $time0 Co > /dev/null
writeCellDataxyz -case $caseNonu -time $time1 T > /dev/null

for file in $caseUniform/$time0/T.xyz $caseUniform/$time1/T.xyz \
            $caseNonu/$time0/Co.xyz $caseNonu/$time1/T.xyz; do
    awk 'NR == 1 {print $0}; NR > 1 {print $0 | "sort -n -k1"}' \
        $file | sponge $file
done

# Make the Courant number file 0 where C>1 and -1 elsewhere
awk 'NR == 1 {print $0}; NR > 1 { if ($4>0.8) print $1, $2, $3, -0.05; else print $1, $2, $3, -1}' \
        $caseNonu/$time0/Co.xyz > $caseNonu/$time0/CoHi.xyz

# Files to plot
inputFiles=($caseUniform/$time0/T.xyz $caseUniform/$time1/T.xyz \
            $caseNonu/$time1/T.xyz $caseNonu/$time0/CoHi.xyz)
outFile=$caseNonu/$time1/Tcompare.eps
col=(4 4 4 4)
colx=1
pens=("black" "black" "black,4_4:0" "4,grey")
symbols=("p0p" "c6p" "x6p" "p0p")
spens=("0,white" "black" "black" "0,white")
legends=("@~y@~@+0@+" "@~y@~@+1@+ uniform, c = 0.4" "@~y@~@+1@+ non-uniform" "c in [0.8,4]")

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
yscale=("*1" "*1" "*1" "*1" )
legPos=x4.7/4.5
projection=X15c/7c
gv=0

. gmtPlot

