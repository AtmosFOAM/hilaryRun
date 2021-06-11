#!/bin/bash -e

# Assemble l2 error norms as a function of resolution for different schemes
cases="weakDeformation/MPDATA_latLon_2gauge_adv
       weakDeformation/MPDATA_latLonRotated_2gauge_adv
       weakDeformation/MPDATA_latLonSkipped_2gauge_adv"
inputFiles=''

for case in $cases; do
    echo '#res dx l1error l2error linf mean var min max' > $case/errorNorms.dat
    inputFiles=(${inputFiles[*]} $case/errorNorms.dat)
    for res in 60 120 240; do
        let twoRes=$res*2
        dir=$case/latLon_${twoRes}x${res}
        if [[ -a $dir/errorNorms.dat ]]; then
            dx=`echo $res | awk '{print 180/$1}'`
            echo -n $res $dx ' ' >> $case/errorNorms.dat
            tail -1 $dir/errorNorms.dat >> $case/errorNorms.dat
        fi
    done
done

# First and 2nd order lines
echo '#res dx 1stOrder 2ndOrder' > plots/1st2ndOrder.dat
echo 0   1 0.001 0.001 >> plots/1st2ndOrder.dat
echo 0   4 0.004 0.016 >> plots/1st2ndOrder.dat

inputFiles=(${inputFiles[*]} 
            plots/1st2ndOrder.dat
            plots/1st2ndOrder.dat)
outFile=plots/l2errorCubedWeak.eps
col=(4 4 4 3 4)
colx=(2 2 2 2 2)
pens=("1p,blue" "1p,red" "1p,magenta"
     "0.5p,black,1_2:0"  "0.5p,black,1_2:0")
symbols=('x8p' 'x8p' 'x1p' 'x1p')
legends=("lat-lon" "rotated" "skipped" "1st/2nd" "order")

xlabel='@~D@~x (degrees)'
#ylabel='l@-2@- error'
xmin=0.5
xmax=15
dx=2
ddx=2
dxg=0
ymin=4e-4
ymax=5e-2
dy=2
ddy=2
dyg=0
xscale=*1
yscale=*1
legPos=x6/0
projection=X9cl/4cl
gv=0

. gmtPlot

