#!/bin/bash -e

# Assemble bounds for different grids
cases="slottedCylinder/QUICK_FCT_latLonPolarRotated_c1/latLon_480x240
       slottedCylinder/QUICK_FCT_HRgrid_c1/HRgrid8"
inputFiles=''

for case in $cases; do
    if [[ -a $case/log ]]; then
        inputFiles=(${inputFiles[*]} $case/bounds.dat)
        echo '#Time min max' > $case/bounds.dat
        grep 'T goes' $case/log | awk '{print $1, $5, $7}' >> $case/bounds.dat
    fi
done

outFile=plots/slottedTmax.eps
col=3
colx=1
pens=("black" "grey")
legends=("lat-lon, c<35" "hexagonal, c<1.02")

xlabel='time'
#ylabel='@~y@~'
xmin=0
xmax=5
dx=1
ddx=0
dxg=0
ymin=0.99999
ymax=1.000001
dy=1e-6
ddy=0
dyg=1
xscale=*1
yscale=*1
legPos=x0.5/0.5
projection=X8c/5c
gv=0

. gmtPlot
evince $outFile &
