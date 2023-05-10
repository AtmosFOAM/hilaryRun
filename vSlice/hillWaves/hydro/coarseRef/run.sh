#!/bin/bash -e

# mesh generation
rm -rf [0-9]* constant/polyMesh constant/muSponge* processor* dynamicCode
blockMesh
terrainFollowingMesh

# create sponge layer
setTracerField -name muSponge -tracerDict "environmentalProperties"

# Initial conditions
cp -r ../init_0 0
setIsothermalBalance
mv 0/Exner constant/Exnera
mv 0/theta constant/thetaa
rm 0/Uf 0/w 0/lnExner

# run
exnerFoamRef >& log & sleep 0.01; tail -f log

