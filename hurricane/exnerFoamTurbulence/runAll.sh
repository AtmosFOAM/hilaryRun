#!/bin/bash -e

# Try to simulate a hurricane with exnerFoamTurbulence

blockMesh
rm -rf [0-9]* core log* *dat postProcessing
cp -r init_0 0

# Initial theta
setInitialTracerField -name theta
sed 's/fixedValue/fixedUniformInternalValue/g' -i 0/theta
# reset theta on upper boundary to be cold
gedit -s 0/theta

# Setup hydrostatic pressure
setExnerBalanced

# run exnerFoamTurbulence
rm -rf [1-9]*
turbulentExnerFoam_RC >& log & sleep 0.01; tail -f log

# Set cells for post-processing
topoSet
time1=30
for set in nearGround nearTop vSlice; do
    subsetMesh $set
    rm -rf $set/constant/polyMesh $set/[0-9]*
    mv $time1/polyMesh $set/constant
    mv $time1 $set/0
done

# Map results and plot on sets
time=600
for set in nearGround nearTop vSlice; do
    rm -rf $set/$time
    mv $set/0 $set/0save
    cp -r init_0 $set/0
    cp constant/Exner_init $set/0/Exner
    mapFields -mapMethod mapNearest -case $set -sourceTime $time .
    mv $set/0 $set/$time
    mv $set/0save $set/0
    
    gmtFoam -time $time -case $set Utheta
    gv $set/$time/Utheta.pdf &
    gmtFoam -time $time -case $set UExner
    gv $set/$time/UExner.pdf &
done

