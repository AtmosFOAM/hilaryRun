#!/bin/bash -e

# Try to simulate a hurricane with exnerFoamTurbulence

blockMesh
rm -rf [0-9]* core log* *dat postProcessing

cp -r ../exnerFoamTurbulence/0 .
cp init_0/p_rgh 0

# Setup hydrostatic pressure
setHydroStaticPressure
# Fix the top boundary conditions
sed -i 's/fixedValue/hydrostatic_p_rgh;\n        gradient uniform 0/g' 0/p_rgh

# run buoyantPimpleFoam
rm -rf [1-9]*
buoyantPimpleFoam >& log & sleep 0.01; tail -f log

# Set cells for post-processing
topoSet
time1=5
for set in nearGround vSlice; do
    subsetMesh $set
    rm -rf $set/constant/polyMesh $set/[0-9]*
    mv $time1/polyMesh $set/constant
    mv $time1 $set/0
done

# Map results and plot on sets
time=600
for set in nearGround vSlice; do
    rm -rf $set/$time
    mv $set/0 $set/0save
    cp -r init_0 $set/0
    mapFields -mapMethod mapNearest -case $set -sourceTime $time .
    mv $set/0 $set/$time
    mv $set/0save $set/0
    
    gmtFoam -time $time -case $set Utheta
    gv $set/$time/Utheta.pdf &
done

