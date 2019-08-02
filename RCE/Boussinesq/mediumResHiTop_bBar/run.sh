#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Initial stratification in the stratosphere
setInitialTracerField -name Nsquared -time 0 -tracerDict setNDict
mv 0/Nsquared constant

# Initial buoyancy perturbations and initial stratification
setInitialTracerField -name bBar -time 0 -tracerDict setbBarDict
mv 0/bBar constant

setFields -time 0
mv 0/Q constant

# Solve Euler equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

# Plots
gmtFoam b
eps2gif b.gif 0/b.pdf ????/b.pdf ?????/b.pdf ??????/b.pdf

