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

# Initial conditions from ../resolved
mapFields -mapMethod cellVolumeWeight $case/../resolved -consistent \
     -noFunctionObjects -sourceTime 0 -case $case
# Overwrite P with correct boundary conditions
cp $case/init_0/P $case/0

# remove bits that are not needed
rm -f 0/massTransfer* 0/divu* 0/u?

# make sure that both partitions are identical
cp $case/0/b $case/0/b.stable
cp $case/0/b $case/0/b.buoyant

