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
mkdir $case/0
cp $case/../../singleFluid/resolved/0/* $case/0

# Use P and p from init_0 instead
cp $case/init_0/P $case/init_0/p.* $case/0

# Divide sigma weighted fields by sigma
for part in stable buoyant; do
    for var in b P uz; do
        multiplyFields -case $case 0 $var.$part 0 sigma$var.$part 0 sigma.$part -pow1 -1
    done
done

# Make b BC zero gradient value
sed -i 's/calculated/zeroGradient/g' $case/0/b.buoyant
sed -i 's/calculated/zeroGradient/g' $case/0/b.stable

rm -f $case/0/*pdf $case/0/divu* $case/0/massTransfer* $case/0/sigmaP* \
      $case/0/sigma?*.* $case/0/Uf* $case/0/u?

# make sigma not go to zero
sumFields 0 sigma 0 sigma.buoyant 0 sigma.sum -scale0 0.8 -scale1 0.1
mv 0/sigma 0/sigma.buoyant
sumFields 0 sigma.stable 0 sigma.sum 0 sigma.buoyant -scale1 -1

# Run
multiFluidBoussinesqFoam -case $case >& $case/log & sleep 0.01; tail -f $case/log

