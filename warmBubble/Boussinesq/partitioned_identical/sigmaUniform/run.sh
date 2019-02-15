#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Stationary initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Add a buoyant perturbation
setInitialTracerField -name b.buoyant -tracerDict setbDict
setInitialTracerField -name b.stable -tracerDict setbDict

#sumFields 0 stable.sigma init_0 stable.sigma 0 buoyant.sigma -scale1 -1

# Plot initial conditions
time=0
gmtFoam sigmab -time $time
gv $time/sigmab.pdf &

# Solve multi-fluid Boussinesq equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

