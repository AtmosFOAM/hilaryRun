##!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: plotOne.sh case
   exit
fi

case=$1
resDir=$1/..

#time=0
#gmtFoam -time $time -case $case UT
#gv $case/$time/UT.pdf &

# Calculate errors
times='0 0.25 0.5 0.75 1'
for time in $times; do
    if [[ -f $case/$time/T ]] ; then
        sumFields -case $case $time Terror $time T ../analytic/$time T_analytic \
            -scale1 -1
    fi
done
time=1
#gmtFoam -case $case vTerror -time $time
#eps2gif $case/vTerror.gif $case/0/vTerror.pdf $case/0.25/vTerror.pdf \
#        $case/0.5/vTerror.pdf $case/0.75/vTerror.pdf $case/1/vTerror.pdf
gv $case/$time/vTerror.pdf &
gmtFoam -case $case -time $time T
gv $case/$time/T.pdf &

# Calculate error norms
globalSum -case $case Terror
globalSum -case $case T

# Normalise error norms
echo Calculating $case/errorNorms.dat
echo '#Time l1 l2 linf mass var' > $case/errorNorms.dat
paste $case/globalSumTerror.dat $resDir/analytic/globalSumT_analytic.dat \
      $case/globalSumT.dat | \
      awk '{if ($1 == 1*$1 && NF == 24 && $2 < 1e10 ) 
        print $1, $2/$10, $3/$11, $4/$12, $5/$13, $22/$14}' \
      >> $case/errorNorms.dat
cat $case/errorNorms.dat

