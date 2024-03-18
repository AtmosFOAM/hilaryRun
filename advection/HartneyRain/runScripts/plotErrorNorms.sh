#!/bin/bash -e

# Collect error norms in one file to plot
echo "#dx l1 l2 linf normMass normVar" > plots/errorNorms.dat
for res in 20 40 80 160; do
    case=cubicRK3_${res}
    tail -1 $case/errorNorms.dat | awk '{print 1/'$res', $2, $3, $4, $5, $6}' \
        >> plots/errorNorms.dat
done

echo -e "#dx error\n0.01 1e-4\n0.1 0.1" > plots/3rdOrder.dat
echo -e "#dx error\n0.01 1e-4\n0.1 0.01" > plots/2ndOrder.dat
echo -e "#dx error\n0.01 1e-4\n0.1 0.001" > plots/1stOrder.dat

inputFiles=(plots/errorNorms.dat \
            plots/3rdOrder.dat  plots/2ndOrder.dat  plots/1stOrder.dat)
outFile=plots/errorNorms.eps
col=(3 2 2 2)
colx=1
legends=("cubic RK3" "1st/2nd/3rd order" "" "")
pens=("1,black" "0.25,black,1_4:0" "0.25,black,1_4:0" "0.25,black,1_4:0")
symbols=("x12p" "" "" "")
spens=("1,black" "" "" "")
xlabel='@~D@~x'
ylabel=''
xmin=0.005
xmax=0.1
dx=10
ddx=2
dxg=10
ymin=1e-5
ymax=0.1
dy=10
ddy=1
dyg=10
xscale=*1
yscale=*1
legPos=x1/8
nSkip=1
projection=X15cl/10cl
gv=0

. gmtPlot
ev $outFile
