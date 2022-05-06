#!/bin/bash -e

# Assemble bounds for different grids
cases="fullDeformation/LW_latLonPolar_c2/latLon_240x120
       fullDeformation/LW_latLonPolarRotated_c2/latLon_240x120
       fullDeformation/LW_latLonPolarSkipped_c2/latLon_240x120
       fullDeformation/LW_cubedSphere_c2/cube_60
       fullDeformation/LW_HRgrid_c2/HRgrid7
       fullDeformation/LW_tri_c2/tri6"
inputFiles=''

for case in $cases; do
    if [[ -a $case/log ]]; then
        inputFiles=(${inputFiles[*]} $case/bounds.dat $case/bounds.dat)
        echo '#Time min max' > $case/bounds.dat
        grep 'T goes' $case/log | awk '{print $1, $5, $7}' >> $case/bounds.dat
    fi
done

outFile=plots/TminMaxGauge.eps
col=(3 2 3 2 3 2 3 2 3 2 3 2)
colx=1
pens=("black" "black,4_4:0"
      "blue" "blue,4_4:1"
      "red" "red,4_4:2"
      "cyan" "cyan,4_4:3"
      "magenta" "magenta,5_5:0"
      "green" "green,5_5:1")
legends=("lat-lon"  "" "rotated" "" "skipped" "" "cubed sphere" "" "hexagonal" "" "triangular" "")

#xlabel='time'
ylabel='@~y@~'
xmin=0
xmax=5
dx=1
ddx=0
dxg=0
ymin=-0.2
ymax=1.2
dy=0.2
ddy=0
dyg=1
xscale=*1
yscale=*1
legPos=x8.5/0.5
projection=X8c/4c
gv=0

. gmtPlot

