#!/bin/bash -e

# Clean up
##########
rm -rf [0-9]* constant/polyMesh constant/muSponge* processor* dynamicCode \
    constant/muSponge

# Mesh and sponge generation
####################
blockMesh
terrainFollowingMesh

# create sponge layer
cp init_0/muSponge constant
setTracerField -name muSponge -tracerDict environmentalProperties

# initial conditions
####################
cp -r init_0 0
setTracerField -name theta -tracerDict thetaDict
setTracerField -name Exner -tracerDict ExnerDict

mv 0/Exner constant/Exnera
mv 0/theta constant/thetaa
mv 0/u 0/w constant
rm 0/Exnerf 0/muSponge

# Run the case
##############
# setup for parallel run
decomposePar -constant
# run
mpirun -np 3 --use-hwthread-cpus exnerFoamRef -parallel > log 2>&1 &

exit

# Post porcessing
reconstructPar; rm -r processor*/[1-9]*; \
writeuvw -latestTime U; \
    gmtFoam  -latestTime w; \
    ev 18000/w.pdf

