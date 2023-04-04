#!/bin/bash -e

# mesh generation
rm -rf [0-9]* constant/polyMesh constant/muSponge* processor*
blockMesh
terrainFollowingMesh

# create sponge layer
setTracerField -name muSponge -tracerDict "environmentalProperties"

# Initial conditions
cp -r ../init_0 0
setIsothermalBalance

# setup for parallel run
decomposePar -constant
# run
mpirun -np 3 --use-hwthread-cpus exnerFoamA -parallel > log 2>&1 &
echo running exnerFoamA, directing out put to log
#sleep 0.01; tail -f log
