#!/bin/bash -e

# mesh generation
rm -rf [0-9]* constant/polyMesh
blockMesh
terrainFollowingMesh

# create sponge layer
createSpongeLayer

# Initial conditions
cp -r init_0 0
setThetaExnerFromT

# run
#exnerFoamA >& log & sleep 0.01; tail -f log
