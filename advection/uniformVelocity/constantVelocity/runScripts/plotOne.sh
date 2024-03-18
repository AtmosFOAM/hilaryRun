##!/bin/bash -e

if [ "$#" -ne 2 ]
then
   echo usage: plotOne.sh resDir case
   exit
fi

resDir=$1
case=$2
dir=$resDir/$case

time=600
#gmtFoam -time $time -case $dir vT
#gv $dir/$time/vT.pdf &

# Calculate errors
times='0 120 240 360 480 600'
for time in $times; do
    if [[ -f $dir/$time/T ]] ; then
        sumFields -case $dir $time Terror $time T ../analytic/$time T_analytic \
            -scale1 -1
    fi
done
#time=600
#gmtFoam -case $dir -time $time Terror
#gv $dir/$time/Terror.pdf &

# Calculate error norms
globalSum -case $dir Terror
globalSum -case $dir T

# Normalise error norms
echo '#Time l1 l2 linf mass var' > $dir/errorNorms.dat
paste $dir/globalSumTerror.dat $resDir/analytic/globalSumT_analytic.dat \
      $dir/globalSumT.dat | \
      awk '{if ($1 == 1*$1 && NF == 24 && $2 < 1e10 ) 
        print $1, $2/$10, $3/$11, $4/$12, $5/$13, $22/$14}' \
      >> $dir/errorNorms.dat

