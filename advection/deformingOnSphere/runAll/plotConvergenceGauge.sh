#!/bin/bash -e

# Assemble l2 error norms as a function of resolution for different grids
cases="fullDeformation/LW_latLonPolar_c2
       fullDeformation/LW_latLonPolarRotated_c2
       fullDeformation/LW_latLonPolarSkipped_c2
       fullDeformation/LW_cubedSphere_c2
       fullDeformation/MPDATA_HRgrid_gauge_c2
       fullDeformation/MPDATA_tri_gauge_c2"
inputFiles=()

for case in $cases; do
    echo $case
    echo '#dx l1error l2error linf mean var min max' > $case/errorNorms.dat
    inputFiles=(${inputFiles[*]} $case/errorNorms.dat)
    
    for dir in $case/*[0-9]; do
        if [[ -a $dir/errorNorms.dat ]]; then
            # Find max dx for this grid
            if [[ ! -a $dir/maxDx.dat ]]; then
                echo 'centre (0 0 0);' >> $dir/system/velocityFieldDict
                meshAnalysis2D -case $dir velocityFieldDict
                gmt info -C $dir/0/distMetrics.dat | awk '{print $4*180/3.14159}' \
                    > $dir/maxDx.dat
            fi
            dx=`cat $dir/maxDx.dat`
            echo -n $dx ' ' >> $case/errorNorms.dat
            tail -1 $dir/errorNorms.dat >> $case/errorNorms.dat
        fi
    done
    sort -n $case/errorNorms.dat | sponge $case/errorNorms.dat
done

# First and 2nd order lines
echo '#dx 1stOrder 2ndOrder' > plots/1st2ndOrder.dat
echo  .4 0.05 0.05 >> plots/1st2ndOrder.dat
echo   2 0.25 2.5 >> plots/1st2ndOrder.dat

inputFiles=(${inputFiles[*]} 
            plots/1st2ndOrder.dat
            plots/1st2ndOrder.dat)
outFile=plots/l2errorGauge.eps
col=(3 3 3 3 3 3 2 3)
colx=(1 1 1 1 1 1 1 1)
pens=("1p,black,4_4:0"
      "1p,blue" "1p,red"  "1p,cyan" "1p,magenta" "1p,green" 
     "0.5p,black,1_2:0"  "0.5p,black,1_2:0")
symbols=('c10p' 
         'x10p' '+10p' 's10p' 'h10p' 't10p'
         'x1p' 'x1p')
legends=("lat-lon c<2"  "rotated" "skipped"
         "cubed sphere"  "hexagonal"  "triangular"  "1st/2nd order")

xlabel='@~D@~x (degrees)'
ylabel='@~i@~@-2@- error'
xmin=0.3
xmax=4.01
dx=2
ddx=2
dxg=0
ymin=2e-2
ymax=1
dy=2
ddy=2
dyg=0
xscale=*1
yscale=*1
legPos=x8.5/0
projection=X8cl/6cl
gv=0

. gmtPlot

