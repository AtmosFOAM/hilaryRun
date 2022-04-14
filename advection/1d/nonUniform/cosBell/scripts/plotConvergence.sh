#!/bin/bash -e

# Plot l2 convergence with resolution

cases="cosBell/LW/mesh1_ cosBell/LW/mesh10_
       cosBell/MPDATA/mesh1_ cosBell/MPDATA/mesh10_
       cosBell/LW_FCT/mesh1_ cosBell/LW_FCT/mesh10_"
inputFiles=()

for case in $cases; do
    echo '#dx l1 l2 linf' > ${case}errorNorms.dat
    for dir in ${case}[0-9]*[0-9]; do
        #dx=`echo $dir | awk -F "$case" '{print 1/$2}'`
        dx=`head -3 $dir/1/T.xyz | tail -1 | awk '{print $1}'`
        tail -1 $dir/errorNorms.dat | awk '{print '$dx', $2, $3, $4}' \
            >> ${case}errorNorms.dat
    done
    sort -n -k 1 ${case}errorNorms.dat | sponge ${case}errorNorms.dat
    inputFiles=(${inputFiles[*]} ${case}errorNorms.dat)
done

echo -e "#1st order\n0.01 0.01\n0.04 0.04" > cosBell/plots/firstOrder.dat
echo -e "2nd order \n0.01 0.01\n0.04 0.16" > cosBell/plots/secondOrder.dat
inputFiles=(${inputFiles[*]} cosBell/plots/firstOrder.dat cosBell/plots/secondOrder.dat)

# Plot options
outFile=cosBell/plots/l2converge.eps
col=(3 3 3 3 3 3 2 2)
colx=1
pens=("black" "black,4_4:0" "1,grey" "1,grey,4_4:0" "1,dimgrey,4_1:0" "1,dimgrey,8_4:0"
      "black,1_2:0" "black,1_2:0")
symbols=("x6p" "+6p" "s10p" "t10p" "c8p" "h8p" "p0p" "p0p")
spens=("1,black" "1,black" "1,grey" "1,grey" "1,dimgrey" "1,dimgrey"
      "black" "black")
legends=("Gauge uniform, c = 0.4" "Gauge ratio 10, c in [0.4, 4]"
         "MPDATA uniform" "MPDATA ratio 10"
         "FCT uniform" "FCT ratio 10"
         "1st/2nd")

xlabel='Max @~D@~x'
xmin=5e-3
xmax=0.03
dx=2
ddx=0
dxg=0
ymin=0.01
ymax=0.5
dy=2
ddy=0
dyg=0
xscale=*1
yscale=("*1" "*1" "*1" )
legPos=x0.3/3.6
projection=X10cl/7cl
gv=0

. gmtPlot

