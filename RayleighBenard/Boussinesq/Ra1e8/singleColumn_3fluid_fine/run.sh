#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Initial buoyancy gradient with perturbation 
setInitialTracerField -name b.stable -time 0
cp 0/b.stable 0/b.up
cp 0/b.stable 0/b.down

# Solve Boussinesq equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

# Post processing

time=500000

./graphs.sh $time

# Nusselt number at the top and bottom
echo '#Time Nusselt0 NusseltTop' > $case/Nusselt.dat
for time in [0-9]*; do
    BoussinesqNusselt.sh $case $time >> $case/Nusselt.dat
done
sort -g -k 1 $case/Nusselt.dat | sponge $case/Nusselt.dat

