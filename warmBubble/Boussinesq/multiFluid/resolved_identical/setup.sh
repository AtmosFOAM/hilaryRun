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

# Make b.buoyant and b.stable identical
cp 0/b 0/b.stable
cp 0/b 0/b.buoyat

rm -f 0/*pdf 0/divu* 0/massTransfer* 0/sigmaP* 0/sigma?*.* 0/Uf* 0/u?

# Run
multiFluidBoussinesqFoam

