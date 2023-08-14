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
terrainFollowingMesh -case $case

# create sponge layer
cp $case/../init_0/muSponge $case/constant
setTracerField -case $case -name muSponge -tracerDict environmentalProperties

# initial conditions
####################
rm -rf $case/0
mkdir $case/0
cp -r $case/../init_0/* $case/0
setTracerField -case $case -name theta -tracerDict thetaDict
setTracerField -case $case -name Exner -tracerDict ExnerDict
mv 0/Exner constant/Exnera
mv 0/theta constant/thetaa
mv 0/u 0/w constant
rm 0/Exnerf 0/muSponge

# Run the case
##############
# setup for parallel run
#decomposePar -constant
# run
#mpirun -np 3 --use-hwthread-cpus exnerFoamRef -parallel > log 2>&1 &
exnerFoamRef -case $case >& $case/log &
echo tail -f $case/log

## Post porcessing
#reconstructPar; rm -r processor*/[1-9]*; \
#writeuvw -latestTime U; \
#    gmtFoam  -latestTime w; \
#    ev 18000/w.pdf

