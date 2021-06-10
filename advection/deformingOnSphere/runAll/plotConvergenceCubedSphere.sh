#!/bin/bash -e

# Assemble l2 error norms as a function of resolution for different schemes
cases="weakDeformation/c08_MPDATA_cubedSphere_2gauge_adv
       weakDeformation/c1p6_MPDATA_cubedSphere_2gauge_adv
       weakDeformation/c3_MPDATA_cubedSphere_2gauge_adv
       weakDeformation/c8_MPDATA_cubedSphere_2gauge_adv"
inputFiles=''

for case in $cases; do
    echo '#res dx l1error l2error linf mean var min max' > $case/errorNorms.dat
    inputFiles=(${inputFiles[*]} $case/errorNorms.dat)
    for res in 15 30 60 120; do
        dir=$case/cube_${res}
        if [[ -a $dir/errorNorms.dat ]]; then
            dx=`echo $res | awk '{print 360/6/$1}'`
            echo -n $res $dx ' ' >> $case/errorNorms.dat
            tail -1 $dir/errorNorms.dat >> $case/errorNorms.dat
        fi
    done
done

# First and 2nd order lines
echo '#res dx 1stOrder 2ndOrder' > plots/1st2ndOrder.dat
echo 360 .4 0.002 0.002 >> plots/1st2ndOrder.dat
echo 36   2 0.01 0.05 >> plots/1st2ndOrder.dat

inputFiles=(${inputFiles[*]} 
            plots/1st2ndOrder.dat
            plots/1st2ndOrder.dat)
outFile=plots/l2errorCubedWeak.eps
col=(4 4 4 4 3 4)
colx=(2 2 2 2 2  2)
pens=("1p,blue" "1p,red" "1p,cyan" "1p,magenta" 
     "0.5p,black,1_2:0"  "0.5p,black,1_2:0")
symbols=('x8p' 'x8p' 'x8p' 'x8p' 'x1p' 'x1p')
legends=("c<0.8" "c<1.6" "c<3" "c<8" "1st/2nd" "order")

xlabel='@~D@~x (degrees)'
#ylabel='l@-2@- error'
xmin=0.4
xmax=15
dx=2
ddx=2
dxg=0
ymin=2e-3
ymax=1
dy=2
ddy=2
dyg=0
xscale=*1
yscale=*1
legPos=x6/0
projection=X9cl/4cl
gv=0

. gmtPlot

