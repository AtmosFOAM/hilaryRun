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
setInitialTracerField -name b.up -time 0
cp 0/b.up 0/b.down

# Solve Boussinesq equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

# Post processing

time=500000

#./graphData.sh . $time
./graphs.sh $time


# Calculate the Nusselt number for every time step
echo '#Time Nusselt0 NusseltTop' > Nusselt.dat
for time in [0-9]*; do
    echo -n $time ' ' >> Nusselt.dat
    BoussinesqNusselt.sh . $time | tail -1 >> Nusselt.dat
done
sort -g -k 1 Nusselt.dat | sponge Nusselt.dat

