#!/bin/bash -e

# Assemble l2 error norms as a function of resolution for different grids
cases="fullDeformation/RK3cubic_latLonPolarRotated_c1
       fullDeformation/RK3cubic_HRgrid_c1"
inputFiles=()

legends=("rotated lat-lon, c~1, c<70"  "hexagonal, c~1"
          "1st/2nd/3rd order")

for case in $cases; do
    echo $case
    echo '#dx l1error l2error linf mean var min max' > $case/errorNorms.dat
    inputFiles=(${inputFiles[*]} $case/errorNorms.dat)
    
    for dir in $case/*[0-9]; do
        if [[ -a $dir/errorNorms.dat ]]; then
            # Find max dx for this grid
            if [[ ! -a $dir/maxDx.dat ]]; then
                cellCentreDistances -case $dir | sort -n | tail -1 |\
                    awk '{print $1*180/3.14159}' > $dir/maxDx.dat
            fi
            dx=`cat $dir/maxDx.dat`
            echo -n $dx ' ' >> $case/errorNorms.dat
            tail -1 $dir/errorNorms.dat >> $case/errorNorms.dat
        fi
    done
    sort -n $case/errorNorms.dat | sponge $case/errorNorms.dat
done

# First and 2nd order lines
echo '#dx 1stOrder 2ndOrder 3rd' > plots/1st2nd3rdOrder.dat
echo 4    1   1   1  >>  plots/1st2nd3rdOrder.dat
echo 0.5  0.125 0.015625 0.001953125 >>  plots/1st2nd3rdOrder.dat

inputFiles=(${inputFiles[*]} 
            plots/1st2nd3rdOrder.dat
            plots/1st2nd3rdOrder.dat
            plots/1st2nd3rdOrder.dat)
outFile=plots/l2errorRKCubic.eps
col=(3 3  2 3 4)
colx=(1 1 1 1 1)
pens=("1p,blue" "1p,red"
     "0.5p,black,1_2:0"  "0.5p,black,1_2:0"  "0.5p,black,1_2:0")
symbols=('c10p' 'h10p'   'x1p' 'x1p' 'x1p')

xlabel='@~D@~x (degrees)'
ylabel='@~i@~@-2@- error'
xmin=0.2
xmax=4.01
dx=2
ddx=2
dxg=0
ymin=1e-3
ymax=1
dy=2
ddy=2
dyg=0
xscale=*1
yscale=*1
legPos=x0.3/4.5
projection=X8cl/6cl
gv=0

. gmtPlot
evince $outFile &
