#!/bin/bash -e

# mesh generation
rm -rf [0-9]* constant/polyMesh constant/muSponge* processor* dynamicCode
blockMesh
terrainFollowingMesh

# create sponge layer
setTracerField -name muSponge -tracerDict "environmentalProperties"

# Initial conditions
cp -r init_0 0
rm 0/P
setIsothermalBalance

# run
exnerFoam_uvw > log 2>&1 & sleep 0.01; tail -f log

#mkdir 0
#setTracerField -tracerDict expHeightTracerDict -name P
#testGradP
