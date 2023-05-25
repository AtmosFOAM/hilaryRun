#!/bin/bash -e

# mesh generation
rm -rf [0-9]* constant/polyMesh constant/muSponge* processor* dynamicCode \
    constant/muSponge
blockMesh
terrainFollowingMesh

# create sponge layer
cp ../init_0/muSponge constant
setTracerField -name muSponge -tracerDict "environmentalProperties"

# Initial conditions
cp -r ../init_0 0
rm 0/P
setIsothermalBalanceH
rm 0/Uf 0/lnExner 0/muSponge 0/Exner?*

# run
exnerFoamHA >& log & sleep 0.01; tail -f log

