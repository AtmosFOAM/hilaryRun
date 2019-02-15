#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Stationary initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Add a buoyant perturbation to the buoyant fluid only
setInitialTracerField -name b.buoyant -tracerDict setbDict

# Create a sigma bubble
setFields
sumFields 0 sigma.stable init_0 sigma.stable 0 sigma.buoyant -scale1 -1

# Plot initial conditions
time=0
gmtFoam sigmab -time $time
gv $time/sigmab.pdf &

# Solve multi-fluid Boussinesq equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

gmtFoam sigmab
eps2gif sigmab.gif 0/sigmab.pdf ??/sigmab.pdf ???/sigmab.pdf \
        ????/sigmab.pdf

