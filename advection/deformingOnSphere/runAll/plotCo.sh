#!/bin/bash -e

# Assemble max Courant number for different grids
cases="fullDeformation/MPDATA_latLon_c2/latLon_240x120
       fullDeformation/MPDATA_latLonRotated_c2/latLon_240x120
       fullDeformation/MPDATA_latLonSkipped_c2/latLon_240x120
       fullDeformation/MPDATA_cubedSphere_c2/cube_60
       fullDeformation/MPDATA_HRgrid_c2/HRgrid7
       fullDeformation/MPDATA_tri_c2/tri6"
inputFiles=''

for case in $cases; do
    if [[ -a $case/log ]]; then
        inputFiles=(${inputFiles[*]} $case/Co.dat $case/Co.dat)

        grep 'Courant Number mean' $case/log | awk '{print $4, $6}' | sed -e "1d" > $case/Co.dat
        echo 0 > $case/time.dat
        grep 'Time =' $case/log | awk '{print $3}' >> $case/time.dat
        paste $case/time.dat $case/Co.dat  | sponge $case/time.dat
        echo '#Time mean max' > $case/Co.dat
        head -n -1 $case/time.dat >> $case/Co.dat
        rm $case/time.dat
    fi
done

outFile=plots/CoMaxMean.eps
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
ylabel='Co'
xmin=0
xmax=5
dx=1
ddx=0
dxg=0
ymin=0.1
ymax=100
dy=10
ddy=0
dyg=0
xscale=*1
yscale=*1
legPos=x8.5/0.5
projection=X8c/4cl
gv=0

. gmtPlot

