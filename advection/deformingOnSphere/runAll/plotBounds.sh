#!/bin/bash -e

# Assemble l2 error norms as a function of resolution for different schemes
cases="results/c08_MPDATA_CN
       results/c1p6_MPDATA_CN
       results/c8_MPDATA_CN
       results/MPDATA_CN
       resultsRotated/MPDATA_CN"
inputFiles=''

for case in $cases; do
#    for res in 60 120 240 360; do
    for res in 240; do
        let twoRes=$res*2
        dir=$case/${twoRes}x${res}
        if [[ -a $dir/log ]]; then
            inputFiles=(${inputFiles[*]} $dir/bounds.dat $dir/bounds.dat)
            echo '#Time min max' > $dir/bounds.dat
            grep goes $dir/log | awk '{print $1, $5, $7}' >> $dir/bounds.dat
        fi
    done
done

outFile=results/plots/TminMax.eps
col=(3 2 3 2 3 2)
colx=1
pens=("black" "black,4_4:0"
      "blue" "blue,4_4:1"
      "red" "red,4_4:2"
      "cyan" "cyan,4_4:3"
      "magenta" "magenta,5_5:0")
legends=("c<0.8" "" "c<1.6" "" "c<8" "" "c~1" "" "rotated" "")

xlabel='time'
#ylabel='l@-2@- error'
xmin=0
xmax=5
dx=1
ddx=0
dxg=0
ymin=-0.1
ymax=1
dy=0.2
ddy=0
dyg=1
xscale=*1
yscale=*1
legPos=x8.5/0
projection=X8c/4c
gv=0

. gmtPlot

#outFile=results/plots/l2errorRes.eps
#colx=(1 1 1)
#xlabel='N (pole to pole)'
#xmin=20
#xmax=500
#legPos=x0.5/0.5
#. gmtPlot
