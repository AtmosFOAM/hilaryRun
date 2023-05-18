#!/bin/bash -e

# mesh generation
rm -rf [0-9]* constant/polyMesh constant/muSponge* processor* dynamicCode
blockMesh
terrainFollowingMesh

# create sponge layer
cp ../init_0/muSponge constant
setTracerField -name muSponge -tracerDict "environmentalProperties"

# Initial conditions
cp -r ../init_0 0
setIsothermalBalance
mv 0/Exner constant/Exnera
mv 0/theta constant/thetaa
rm 0/Uf 0/lnExner 0/muSponge

# run
exnerFoamRefuvw >& log & sleep 0.01; tail -f log

# Thing to test
Simplify code
impicit/explicit on everything 
large time steps - stable for ocCeoff=0.8,0.9 but not convergent
hydrostatic/non-hydrostatic
off centering 0.8 or 0.9 for stability
