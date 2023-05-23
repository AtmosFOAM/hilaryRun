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
setIsothermalBalance
mv 0/Exner constant/Exnera
mv 0/theta constant/thetaa
rm 0/Uf 0/lnExner 0/muSponge 0/Exnerg

# setup for parallel run
decomposePar -constant
# run
mpirun -np 3 --use-hwthread-cpus exnerFoamRef -parallel > log 2>&1 &
echo running exnerFoamA, directing out put to log
#sleep 0.01; tail -f log
