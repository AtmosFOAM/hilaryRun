#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log processor*

# create mesh and plot
blockMesh

# hydrostatically balanced initial conditions with a warm perturbation
mkdir 0
cp -r init_0/* 0
setTracerField -name Exnera -tracerDict ExnerDict
setTracerField -name thetap -tracerDict thetaDict
mv 0/Exnera 0/thetaa 0/u 0/w constant
rm 0/Exneraf

# Run the case
##############
# setup for parallel run
decomposePar -constant
# run
mpirun -np 4 --use-hwthread-cpus exnerFoamRef -parallel > log 2>&1 &

exit

# Post porcessing
reconstructPar; rm -r processor*/[1-9]*; \
writeuvw -latestTime U; \
    gmtFoam  -latestTime w; \
    ev 18000/w.pdf

