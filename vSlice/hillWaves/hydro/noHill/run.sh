#!/bin/bash -e

# mesh generation
rm -rf [0-9]* constant/polyMesh constant/muSponge* processor*
blockMesh

# Initial conditions
cp -r ../init_0 0
setIsothermalBalance

# run
exnerFoamA  > log 2>&1 & sleep 0.01; tail -f log

