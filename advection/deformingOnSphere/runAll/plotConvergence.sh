#!/bin/bash -e

# Assemble l2 error norms as a function of resolution for different schemes
cases="results/c08_MPDATA_CN
       results/c1p6_MPDATA_CN
       results/c8_MPDATA_CN
       results/MPDATA_CN
       resultsRotated/MPDATA_CN
       results/c08_upwind_BE"
inputFiles=''

for case in $cases; do
    echo '#res dx l1error l2error linf mean var min max' > $case/errorNorms.dat
    inputFiles=(${inputFiles[*]} $case/errorNorms.dat)
    for res in 60 120 240 360; do
        let twoRes=$res*2
        dir=$case/${twoRes}x${res}
        if [[ -a $dir/errorNorms.dat ]]; then
            dx=`echo $res | awk '{print 180/$1}'`
            echo -n $res $dx ' ' >> $case/errorNorms.dat
            tail -1 $dir/errorNorms.dat >> $case/errorNorms.dat
        fi
    done
done

# First and 2nd order lines
echo '#res dx 1stOrder 2ndOrder' > results/plots/1st2ndOrder.dat
echo 360 .4 0.05 0.05 >> results/plots/1st2ndOrder.dat
echo 36   2 0.25 2.5 >> results/plots/1st2ndOrder.dat

inputFiles=(${inputFiles[*]} 
            results/plots/1st2ndOrder.dat
            results/plots/1st2ndOrder.dat)
outFile=results/plots/l2error.eps
col=(4 4 4 4 4 4 3 4)
colx=(2 2 2 2 2 2 2 2)
pens=("1p,black" "1p,blue" "1p,red"
     "0.5p,grey,4_4:0" "0.5p,cyan,4_4:0"  "0.5p,magenta,4_4:0"
     "0.5p,black,1_2:0"  "0.5p,black,1_2:0")
symbols=('c10p' '+14p' 'x14p'
         't10p' 'i10p' 's6p' 
         'x1p' 'x1p')
pens=("1p,black" "1p,blue" "1p,red"
     "0.5p,cyan"  "0.5p,magenta" "0.5p,grey"
     "0.5p,black,1_2:0"  "0.5p,black,1_2:0")
legends=("c<0.8" "c<1.6" "c<8"
         "c~1" "Rotated lat-lon" "upwind, c<0.8" "1st/2nd order")

xlabel='@~D@~x (degrees)'
#ylabel='l@-2@- error'
xmin=0.4
xmax=4
dx=2
ddx=2
dxg=0
ymin=5e-2
ymax=1
dy=2
ddy=2
dyg=0
xscale=*1
yscale=*1
legPos=x8.5/0
projection=X8cl/4cl
gv=0

. gmtPlot

#outFile=results/plots/l2errorRes.eps
#colx=(1 1 1)
#xlabel='N (pole to pole)'
#xmin=20
#xmax=500
#legPos=x0.5/0.5
#. gmtPlot
