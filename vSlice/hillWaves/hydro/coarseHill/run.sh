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
setIsothermalBalance
rm 0/Uf 0/lnExner 0/muSponge 0/Exner?*
cp 0/Exner 0/Exner_0
cp 0/U 0/U_0
cp 0/theta 0/theta_0

# run
exnerFoamA > log 2>&1 & sleep 0.01; tail -f log

# Testing
Sponge Hydro impGW impU impT iters dt ocCoeff conv   solution

