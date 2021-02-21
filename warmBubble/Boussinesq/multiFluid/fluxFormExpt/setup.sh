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

# Use P and p from init_0 instead
cp $case/init_0/P $case/init_0/p.* $case/0

# Divide sigma weighted fields by sigma
for part in stable buoyant; do
    for var in b P uz; do
        multiplyFields -case $case 0 $var.$part 0 sigma$var.$part 0 sigma.$part -pow1 -1
    done
done

# Make b zero gradient
sed -i 's/calculated/fixedValue/g' 0/b.buoyant
sed -i 's/calculated/fixedValue/g' 0/b.stable

