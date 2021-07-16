#!/bin/bash -e

# Assemble max Courant number for different grids
cases="weakDeformation/MPDATA_latLon_2gauge_adv/latLon_240x120
      weakDeformation/MPDATA_latLonRotated_2gauge_adv/latLon_240x120
      weakDeformation/MPDATA_latLonSkipped_2gauge_adv/latLon_240x120
      weakDeformation/c2_MPDATA_cubedSphere_2gauge_adv/cube_60
      weakDeformation/MPDATA_HRgrid_2gauge_adv/HRgrid7
      weakDeformation/MPDATA_tri_2gauge_adv/tri6"
inputFiles=''

for case in $cases; do
    if [[ -a $case/log ]]; then
        inputFiles=(${inputFiles[*]} $case/Co.dat)

        grep 'Courant Number mean' $case/log | awk '{print $4, $6}' | sed -e "1d" > $case/Co.dat
        echo 0 > $case/time.dat
        grep 'Time =' $case/log | awk '{print $3}' >> $case/time.dat
        paste $case/time.dat $case/Co.dat  | sponge $case/time.dat
        echo '#Time mean max' > $case/Co.dat
        head -n -1 $case/time.dat >> $case/Co.dat
        rm $case/time.dat
    fi
done

outFile=plots/CoMaxMeanWeak.eps
col=(3 3 3 3 3 3)
colx=1
pens=("black" 
      "blue" 
      "red" 
      "cyan" 
      "magenta"
      "green" )
#legends=("lat-lon"  "" "rotated" "" "skipped" "" "cubed sphere" "" "hexagonal" "" "triangular" "")

xlabel='time'
xmin=0
xmax=5
dx=1
ddx=0
dxg=0
ymin=0.1
ymax=50
dy=10
ddy=0
dyg=0
xscale=*1
yscale=*1
legPos=x0.5/0.5
projection=X8c/4cl
gv=0

. gmtPlot

