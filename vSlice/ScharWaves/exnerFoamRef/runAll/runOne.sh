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
setTracerField -case $case -name theta -tracerDict thetaDict -time 0
setTracerField -case $case -name Exner -tracerDict ExnerDict -time 0
mv $case/0/Exner $case/constant/Exnera
mv $case/0/theta $case/constant/thetaa
mv $case/0/u $case/0/w $case/constant
rm $case/0/Exnerf $case/0/muSponge

# Run the case
##############
# setup for parallel run
#decomposePar -constant -case $case
# run
#mpirun -np 3 --use-hwthread-cpus exnerFoamRef -case $case -parallel > $case/log 2>&1 &
exnerFoamRef -case $case >& $case/log &
echo tail -f $case/log

## Post porcessing
#reconstructPar; rm -r processor*/[1-9]*; \
#writeuvw -latestTime U; \
#    gmtFoam  -latestTime w; \
#    ev 18000/w.pdf

