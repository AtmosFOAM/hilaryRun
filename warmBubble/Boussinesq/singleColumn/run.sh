#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Stationary initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Create non-uniform sigma and Stransfer fields
setFields -dict system/setTransferDict
cp 0/transferLocation.stable 0/transferLocation.buoyant
setFields -dict system/setSigmaDict
sumFields 0 sigma.stable init_0 sigma.stable 0 sigma.buoyant -scale1 -1

# Solve multi-fluid Boussinesq equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

gmtFoam sigmab
eps2gif sigmab.gif 0/sigmab.pdf ??/sigmab.pdf ???/sigmab.pdf \
        ????/sigmab.pdf

