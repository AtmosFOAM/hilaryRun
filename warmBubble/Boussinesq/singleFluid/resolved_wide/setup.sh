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

# Run for one time step
multiFluidBoussinesqFoam

# Re-define sigma based on w at time 2
writeuvw u -time 2
topoSet -case $case -dict system/conditionalSamplingDictw -time 2
setFields -case $case -dict system/conditionalSamplingDict \
            -time 0 -noFunctionObjects

# Remove un-necessary fields
rm -r 2 0/massTransfer* 0/sigma.sum

# Create sigma weighted fields
for part in stable buoyant; do
    for var in b; do
        multiplyFields -case $case 0 sigma$var.$part 0 $var.$part 0 sigma.$part
    done
done

