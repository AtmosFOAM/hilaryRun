#!/bin/bash -e

# Assemble l2 error norms as a function of resolution for different grids
cases="fullDeformation/QUICK_HRgrid_c1
       fullDeformation/QUICK_HRgrid_c2
       fullDeformation/QUICK_HRgrid_c4
       fullDeformation/QUICK_HRgrid_c8"

ress=("HRgrid6" "HRgrid7" "HRgrid8" "HRgrid9")

legends=("hexagonal" "1st/2nd order")
data=plots/QUICK_HRgrid_dx.dat

echo sending data to $data

echo '#dx l1error l2error linf mean var min max' > $data

ic=0
for case in $cases; do
    dir=$case/${ress[$ic]}
    let ic=$ic+1
    echo $dir
    
    if [[ -a $dir/errorNorms.dat ]]; then
        # Find max dx for this grid
        if [[ ! -a $dir/maxDx.dat ]]; then
            cellCentreDistances -case $dir | sort -n | tail -1 |\
                awk '{print $1*180/3.14159}' > $dir/maxDx.dat
        fi
        dx=`cat $dir/maxDx.dat`
        echo -n $dx ' ' >> $data
        tail -1 $dir/errorNorms.dat >> $data
    fi
done

# First and 2nd order lines
echo '#dx 1stOrder 2ndOrder' > plots/1st2ndOrder.dat
echo  0.5 0.02 0.02 >> plots/1st2ndOrder.dat
echo  4   0.16 1.28 >> plots/1st2ndOrder.dat

inputFiles=($data
            plots/1st2ndOrder.dat
            plots/1st2ndOrder.dat)
outFile=plots/l2errorQUICK_dx.eps
col=(3 2 3)
colx=(1 1 1)
pens=("1p,green"
     "0.5p,black,1_2:0"  "0.5p,black,1_2:0")
symbols=('h10p' 'x1p' 'x1p')

xlabel='@~D@~x'
ylabel='@~i@~@-2@- error'
xmin=0.2
xmax=5
dx=2
ddx=2
dxg=0
ymin=0.01
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

