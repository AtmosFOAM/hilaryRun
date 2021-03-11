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

# Use initial conditions from init_0
mkdir -p 0
cp $case/init_0/* $case/0

# Initial conditions of b from ../../singleFluid/resolved
cp $case/../../singleFluid/resolved/0/b $case/0
#for part in stable buoyant downdraft; do
#    cp $case/0/b $case/0/b.$part
#done

# Set up non-uniform sigma fields
setFields -case $case -dict system/sigmaSetFieldsDict
sumFields -case $case 0 sigma12 0 sigma.buoyant 0 sigma.downdraft
sumFields -case $case 0 sigma.stable 0 sigma 0 sigma12 -scale1 -1
rm $case/0/sigma12

# If sigma=0 make b=0 (only works for sigma = 0 or 1)
for part in stable buoyant downdraft; do
    multiplyFields -case $case 0 b.$part 0 b 0 sigma.$part
done

# Make all sigma>0.1
sumFields -case $case 0 sigma.buoyant 0 sigma.buoyant 0 sigma -scale0 0.7 -scale1 0.1
sumFields -case $case 0 sigma.downdraft 0 sigma.downdraft 0 sigma -scale0 0.7 -scale1 0.1
sumFields -case $case 0 sigma12 0 sigma.buoyant 0 sigma.downdraft
sumFields -case $case 0 sigma.stable 0 sigma 0 sigma12 -scale1 -1
rm $case/0/sigma12

# Run
multiFluidBoussinesqFoam -case $case >& $case/log & sleep 0.01; tail -f $case/log


