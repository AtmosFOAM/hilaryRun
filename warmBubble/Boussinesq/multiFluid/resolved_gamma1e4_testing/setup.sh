#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: ./setup.sh caseName
   exit
fi

case=$1

# clear out old stuff
rm -rf $case/[0-9]* $case/constant/polyMesh $case/core $case/log

# create mesh
blockMesh -case $case

# Initial conditions from ../../singleFluid/resolved
mkdir 0
fromDir=../../singleFluid/resolved
for var in sigma b u; do
    cp $fromDir/0/$var.buoyant $fromDir/0/$var.stable 0
done

# Use P from init_0 instead
cp $case/init_0/P $case/0

# make sigma a passive tracer
setInitialTracerField -name sigma.buoyant -tracerDict setSigmaDict -case $case
sumFields 0 sigma.stable 0 sigma.buoyant init_0 sigma.stable -scale0 -1
