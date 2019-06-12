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

# Use P from init_0 instead
cp $case/init_0/P $case/0

# Divide sigma weighted fields by sigma
for part in stable buoyant; do
    for var in b; do
        multiplyFields -case $case 0 $var.$part 0 sigma$var.$part 0 sigma.$part -pow1 -1
    done
done

