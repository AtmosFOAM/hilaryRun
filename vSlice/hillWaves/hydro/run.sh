#!/bin/bash -e

# mesh generation
rm -rf [0-9]* constant/polyMesh constant/muSponge* processor*
blockMesh
terrainFollowingMesh

# create sponge layer
setAnalyticTracerField -name muSponge -tracerDict "environmentalProperties"

# Initial conditions
cp -r ../init_0 0
setThetaExnerFromT

# setup for parallel run
decomposePar -constant
# run
mpirun -np 4 exnerFoamA -parallel > log 2>&1 &
echo running exnerFoamA, directing out put to log
#sleep 0.01; tail -f log
