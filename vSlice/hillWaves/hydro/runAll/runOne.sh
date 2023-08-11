#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: runOne.sh case
   exit
fi

case=$1

# mesh generation
rm -rf $case/[0-9]* $case/constant/polyMesh $case/constant/muSponge* $case/processor* $case/dynamicCode \
    $case/constant/muSponge
blockMesh -case $case
terrainFollowingMesh -case $case

# create sponge layer
cp runAll/init_0/muSponge $case/constant
setTracerField -case $case -name muSponge -tracerDict "environmentalProperties"

# Initial conditions
cp -r runAll/init_0 $case/0
setIsothermalBalance -case $case
mv $case/0/Exner $case/constant/Exnera
mv $case/0/theta $case/constant/thetaa
mv $case/0/u $case/0/w $case/constant
rm $case/0/P $case/0/Uf $case/0/lnExner $case/0/muSponge $case/0/Exnerg

# setup for parallel run
#decomposePar -constant -case $case
# run
#mpirun -np 3 --use-hwthread-cpus exnerFoamRef -case $case -parallel > $case/log 2>&1 &
exnerFoamRef -case $case >& $case/log &
echo tail -f $case/log
