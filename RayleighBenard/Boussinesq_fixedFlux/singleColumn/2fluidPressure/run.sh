#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Solve Boussinesq equations
multiFluidBoussinesqFoamPressure >& log & sleep 0.01; tail -f log

# Draw graphs
for time in *0000; do
    ./graphs.sh $time
done

