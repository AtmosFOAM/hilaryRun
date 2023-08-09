#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log processor* dynamicCode *.dat \
    constant/Exnera constant/thetaa constant/u constant/w

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0
mv 0/Exnera 0/thetaa 0/u 0/w constant

# add Gaussian random noise to thetap
postProcess -func randomise -time 0
mv 0/'randomise(thetap)' 0/thetap

decomposePar -constant

# Solve NS equations
mpirun -np 4 --use-hwthread-cpus exnerFoamRef -parallel >& log &

exit

# Post process
rm -r [1-9]*; reconstructPar; rm -r processor*/[1-9]*; \
    postProcess -latestTime -func CourantNoU; \
    gmtFoam  -latestTime bc;     ev `ls -rt */bc.pdf | tail -1`

../plots/calcNu.sh . 1 30
../plots/calcRe.sh . 1 30

