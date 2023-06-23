#!/bin/bash -e

# Assemble l2 error norms as a function of resolution for different grids
cases="fullDeformation/QUICK_cubedSphere_c025
       fullDeformation/QUICK_cubedSphere_c05
       fullDeformation/QUICK_cubedSphere_c1
       fullDeformation/QUICK_cubedSphere_c2
       fullDeformation/QUICK_cubedSphere_c5
       fullDeformation/QUICK_cubedSphere_c10
       "

legends=("cubed sphere" "1st/2nd order")
data=plots/QUICK_cubedSphere_c.dat
res=cube_60

echo '#dt l1error l2error linf mean var min max' > $data

for case in $cases; do
    echo $case
    
    for dir in $case/$res; do
        if [[ -a $dir/errorNorms.dat ]]; then
            # Find dt for this case
            dt=`grep deltaT $dir/system/controlDict | awk '{print $2}' |
                awk -F';' '{print $1}'`
            echo -n $dt ' ' >> $data
            tail -1 $dir/errorNorms.dat >> $data
        fi
    done
done

# First and 2nd order lines
echo '#dx 1stOrder 2ndOrder' > plots/1st2ndOrder.dat
echo  0.01 0.1 0.1 >> plots/1st2ndOrder.dat
echo  0.1   1 10 >> plots/1st2ndOrder.dat

inputFiles=($data
            plots/1st2ndOrder.dat
            plots/1st2ndOrder.dat)
outFile=plots/l2errorQUICK_dt.eps
col=(3 2 3)
colx=(1 1 1)
pens=("1p,black"
     "0.5p,black,1_2:0"  "0.5p,black,1_2:0")
symbols=('s10p' 'x1p' 'x1p')

xlabel='@~D@~t'
ylabel='@~i@~@-2@- error'
xmin=0.00124
xmax=0.051
dx=2
ddx=2
dxg=0
ymin=0.1
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

