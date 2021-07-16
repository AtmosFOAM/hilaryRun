#!/bin/bash -e

# Assemble l2 error norms as a function of resolution for different grids
cases="weakDeformation/MPDATA_latLon_2gauge_adv
      weakDeformation/MPDATA_latLonRotated_2gauge_adv
      weakDeformation/MPDATA_latLonSkipped_2gauge_adv
      weakDeformation/c1_MPDATA_cubedSphere_2gauge_adv
      weakDeformation/c2_MPDATA_cubedSphere_2gauge_adv
      weakDeformation/c4_MPDATA_cubedSphere_2gauge_adv
      weakDeformation/c8_MPDATA_cubedSphere_2gauge_adv
      weakDeformation/MPDATA_HRgrid_2gauge_adv
      weakDeformation/MPDATA_tri_2gauge_adv"
inputFiles=()

for case in $cases; do
    echo $case
    echo '#dx l1error l2error linf mean var min max' > $case/errorNorms.dat
    inputFiles=(${inputFiles[*]} $case/errorNorms.dat)
    
    for dir in $case/*[0-9]; do
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
    done
    sort -n $case/errorNorms.dat | sponge $case/errorNorms.dat
done

# First and 2nd order lines
echo '#dx 1stOrder 2ndOrder' > plots/1st2ndOrder.dat
echo   2 0.05 0.05 >> plots/1st2ndOrder.dat
echo  .4 0.01 0.002 >> plots/1st2ndOrder.dat

inputFiles=(${inputFiles[*]} 
            plots/1st2ndOrder.dat
            plots/1st2ndOrder.dat)
outFile=plots/l2errorWeak.eps
col=(3 3 3 3 3 3 3 3 3 2 3)
colx=(1 1 1 1 1 1 1 1 1 1 1)
pens=("1p,black" "1p,blue" "1p,red"  
     "1p,cyan" "1p,cyan,4_4:0" "1p,cyan,2_2:0" "cyan,1_1:0"
     "1p,magenta" "1p,green" 
     "0.5p,black,1_2:0"  "0.5p,black,1_2:0")
symbols=('c10p' 'x10p' '+10p'
         's10p' 's10p' 's10p' 's10p' 'h10p' 't10p'
         'x1p' 'x1p')
legends=("lat-lon c<1"   "rotated c>60" "skipped c<2"
         "cubed sphere c<1" "cubed sphere c<2" "cubed sphere c<4" "cubed sphere c<8"  "hexagonal c~1"  "triangular c~1"  "1st/2nd order")

xlabel='@~D@~x (degrees)'
#ylabel='l@-2@- error'
xmin=0.3
xmax=10
dx=2
ddx=2
dxg=0
ymin=2e-4
ymax=0.8
dy=2
ddy=2
dyg=0
xscale=*1
yscale=*1
legPos=x8.5/0
projection=X8cl/6cl
gv=0

. gmtPlot

