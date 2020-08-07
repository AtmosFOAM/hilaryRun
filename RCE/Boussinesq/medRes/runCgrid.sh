#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: runCgrid.sh case
   exit
fi

case=$1

# clear out old stuff
rm -rf $case/[0-9]* $case/constant/polyMesh $case/core $case/log

# create mesh
blockMesh -case $case

# Initial conditions
rm -rf $case/[0-9]* $case/core
mkdir $case/0
cp -r $case/init_0/* $case/0

# Initial buoyancy perturbation
setFields -time 0 -case $case

# Solve Euler equations
boussinesqFoam -case $case >& $case/log &

