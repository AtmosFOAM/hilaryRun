#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: runOne.sh case
   exit
fi

case=$1

# clear out old stuff
rm -rf $case/[0-9]* $case/constant/polyMesh core $case/core $case/log \
    $case/processor* $case/dynamicCode $case/*.dat $case/constant/Exnera \
    $case/constant/thetaa $case/constant/u $case/constant/w

# create mesh
blockMesh -case $case

# Initial conditions
rm -rf $case/0
mkdir $case/0
cp -r $case/../../runAll/init_0/* $case/0
mv $case/0/Exnera $case/0/thetaa $case/0/u $case/0/w $case/constant

# add Gaussian random noise to thetap
postProcess -case $case -func randomise -time 0
mv $case/0/'randomise(thetap)' $case/0/thetap

#decomposePar -case $case -constant

# Solve NS equations
#mpirun -np 2 --use-hwthread-cpus exnerFoamRef -case $case -parallel >& $case/log &
exnerFoamRef -case $case >& $case/log &
echo tail -f $case/log
