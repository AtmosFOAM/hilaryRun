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
    $case/constant/thetaa $case/constant/[u-w]

# create mesh
blockMesh -case $case

# hydrostatically balanced initial conditions with a warm perturbation
rm -rf $case/0
mkdir $case/0
cp -r $case/../runAll/init_0/* $case/0
setTracerField -case $case -name Exnera -tracerDict ExnerDict
setTracerField -case $case -name thetap -tracerDict thetaDict
mv $case/0/Exnera $case/0/thetaa $case/0/[u-w] $case/constant
rm $case/0/Exneraf

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
#    postProcess -func CourantNoU -lastestTime; \
#    gmtFoam  -latestTime thetaC; \
#    ev 1000/thetaC.pdf

