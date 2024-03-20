#!/bin/bash -e

# Assemble bounds for different grids
cases="slottedCylinder/cubic_FCT_latLonPolarRotated_c1/latLon_480x240
       slottedCylinder/QUICK_FCT_HRgrid_c1/HRgrid8"
inputFiles=''

for case in $cases; do
    if [[ -a $case/log ]]; then
        inputFiles=(${inputFiles[*]} $case/mass.dat)
        echo '#Time normalisedMassChange' > $case/mass.dat
        grep 'normalised T mass change' $case/log | awk '{print $1, $13}' >> $case/mass.dat
    fi
done

outFile=plots/massErrorSlotted.eps
col=2
colx=1
pens=("black" "grey")
legends=("lat-lon, c<35" "hexagonal, c<1.02")

xlabel='time'
xmin=0
xmax=5
dx=1
ddx=0
dxg=0
ymin=-3e-13
ymax=3e-14
dy=1e-13
ddy=0
dyg=10
xscale=*1
yscale=*1
legPos=x0.9/2.5
projection=X8c/5c
gv=0

. gmtPlot
evince $outFile &
