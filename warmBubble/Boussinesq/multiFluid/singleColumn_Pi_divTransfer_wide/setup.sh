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

# Initial conditions from singleColumn_Pi_divTransfer
cp -r $case/../singleColumn_Pi_divTransfer/0 $case

# Divide sigma.buoyant by 2
sumFields -case $case 0 sigma.buoyant 0 sigma.buoyant 0 sigma.buoyant -scale0 0.5 -scale1 0
sumFields -case $case 0 sigma.stable init_0 sigma.stable 0 sigma.buoyant -scale1 -1

