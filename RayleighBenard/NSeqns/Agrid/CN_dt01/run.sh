#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log processor*

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# add Gaussian random noise to theta.stable
postProcess -func randomise -time 0
mv 0/theta 0/theta_init
mv 0/'randomise(theta)' 0/theta

decomposePar -constant

# Solve Euler equations
mpirun -np 3 --use-hwthread-cpus exnerFoamA -parallel >& log &

