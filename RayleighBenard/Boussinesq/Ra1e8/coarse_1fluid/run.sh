#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log hMeans/[0-9]* hMeans/constant/polyMesh

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Initial buoyancy gradient with perturbation 
setInitialTracerField -name b.air -time 0
setFields -time 0

# Solve Boussinesq equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log


