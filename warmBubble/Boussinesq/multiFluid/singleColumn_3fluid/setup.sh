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
mapFields -case $case -mapMethod cellVolumeWeight \
      $case/../../singleFluid/resolved \
     -consistent -noFunctionObjects -sourceTime 0
changeAllNames buoyant up 0/*.buoyant*

# Use some initial conditions from init_0
cp $case/init_0/P $case/init_0/p.up $case/init_0/p.stable \
   $case/init_0/*.down $case/0

# Divide sigma weighted fields by sigma
for part in stable up; do
    for var in b P uz; do
        multiplyFields -case $case 0 $var.$part 0 sigma$var.$part 0 sigma.$part -pow1 -1
    done
done

# Run
multiFluidBoussinesqFoam -case $case >& $case/log & sleep 0.01; tail -f $case/log



