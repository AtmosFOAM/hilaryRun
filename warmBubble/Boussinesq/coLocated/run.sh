#!/bin/bash -e

# Setup warm rising bubble test case for BoussinesqFoam_Agrid

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Stationary initial conditions
mkdir 0
cp -r init_0/* 0

# Add a buoyant perturbation
setInitialTracerField -name b -tracerDict setbDict

BoussinesqFoam_Agrid >& log & sleep 0.01; tail -f log

