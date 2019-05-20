#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Initial buoyancy perturbations and transfer at the ground
setFields
time=0
gmtFoam -time $time bstable
gv $time/bstable.pdf &

# Solve Euler equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

