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

# Stationary initial conditions
mkdir $case/0
cp -r $case/init_0/* $case/0

# Add a buoyant perturbation
setInitialTracerField -name b.buoyant -tracerDict setbDict -case $case
setInitialTracerField -name b.stable -tracerDict setbDict -case $case
setInitialTracerField -name b -tracerDict setbDict -case $case

multiFluidBoussinesqFoam

# Re-define sigma based on w aat time 2
#topoSet -case $case -dict system/conditionalSamplingDictb -time 0
writeuvw u -time 2
topoSet -case $case -dict system/conditionalSamplingDictw -time 2
setFields -case $case -dict system/conditionalSamplingDict \
            -time 0 -noFunctionObjects
mv 2/sigma.* 0
rm -r 2
