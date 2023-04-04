#!/bin/bash -e

# mesh generation
rm -rf [0-9]* constant/polyMesh
blockMesh
terrainFollowingMesh

# Initial conditions
cp -r init_0 0
setTracerField -name P

# run
testGradP
