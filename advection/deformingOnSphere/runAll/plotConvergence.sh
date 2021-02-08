#!/bin/bash -e

# Assemble l2 error norms as a function of resolution
echo '#res dx l1error l2error linf mean var min max' > results/plots/errorNorms.dat
for res in 60 120 240 360; do
    let twoRes=$res*2
    dir=results/c08_expGauge_2_noSmoothvAdvCorr_noPolarCell/${twoRes}x${res}
    dx=`echo $res | awk '{print 180/$1}'`
    echo -n $res $dx ' ' >> results/plots/errorNorms.dat
    tail -1 $dir/errorNorms.dat >> results/plots/errorNorms.dat
done

# First and 2nd order lines
echo '#res dx 1stOrder 2ndOrder' > results/plots/1st2ndOrder.dat
echo 180 1 0.01 0.01 >> results/plots/1st2ndOrder.dat
echo 18 10 0.1 1 >> results/plots/1st2ndOrder.dat

inputFiles=(results/plots/errorNorms.dat
            results/plots/1st2ndOrder.dat
            results/plots/1st2ndOrder.dat)
outFile=results/plots/l2error.eps
col=(4 3 4)
colx=(2 2 2)
pens=("1p,black" "0.5p,black,1_2:0"  "0.5p,black,1_2:0")
symbols=('c10p' 'x1p' 'x1p')
spens=("1p,black" "1p,grey" "1p,grey")

xlabel='@~D@~x (degrees)'
#ylabel='l@-2@- error'
xmin=0.1
xmax=10
dx=2
ddx=2
dxg=10
ymin=1e-2
ymax=1
dy=2
ddy=2
dyg=10
xscale=*1
yscale=*1
legPos=x0.1/3
projection=X10cl/10cl
gv=0

. gmtPlot

outFile=results/plots/l2errorRes.eps
colx=(1 1 1)
xlabel='N (pole to pole)'
xmin=10
xmax=500
. gmtPlot
