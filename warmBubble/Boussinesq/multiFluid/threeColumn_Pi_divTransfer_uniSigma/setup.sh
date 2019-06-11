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

# Use sigma from init_0
sigmaValues=''
for i in {1..100}; do sigmaValues="$sigmaValues 0 0.6 0" ; done
sed 's/REPLACE/'"$sigmaValues"'/g' $case/init_0/sigma.buoyant > $case/0/sigma.buoyant
sumFields -case $case 0 sigma.stable init_0 sigma.stable 0 sigma.buoyant -scale1 -1

# Divide sigma weighted fields by sigma
for part in stable buoyant; do
    for var in b P uz; do
        multiplyFields -case $case 0 $var.$part 0 sigma$var.$part 0 sigma.$part -pow1 -1
    done
done

