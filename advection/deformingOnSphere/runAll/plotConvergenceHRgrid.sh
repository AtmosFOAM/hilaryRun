#!/bin/bash -e

# Assemble l2 error norms as a function of resolution for different schemes
cases="weakDeformation/MPDATA_HRgrid_2gauge_adv"
inputFiles=''

for case in $cases; do
    echo '#res dx l1error l2error linf mean var min max' > $case/errorNorms.dat
    inputFiles=(${inputFiles[*]} $case/errorNorms.dat)
    for res in 4 5 6 7 8; do
        dir=$case/HRgrid${res}
        if [[ -a $dir/errorNorms.dat ]]; then
            dx=`echo $res | awk '{print 180/3.14159*0.150184*4/2**($1-2)}'`
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
outFile=plots/l2errorHRgridWeak.eps
col=(4 3 4)
colx=(2 2 2)
pens=("1p,blue" 
     "0.5p,black,1_2:0"  "0.5p,black,1_2:0")
symbols=('x8p'  'x1p' 'x1p')
legends=("Hexagonal" "1st/2nd" "order")

xlabel='@~D@~x (degrees)'
#ylabel='l@-2@- error'
xmin=0.5
xmax=15
dx=2
ddx=2
dxg=0
ymin=1e-3
ymax=0.3
dy=2
ddy=2
dyg=0
xscale=*1
yscale=*1
legPos=x6/0
projection=X9cl/4cl
gv=0

. gmtPlot

