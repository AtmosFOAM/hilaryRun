#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log hMeans/[0-9]* hMeans/constant/polyMesh

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Initial buoyancy gradient with perturbation 
setInitialTracerField -name b.air -time 0
setFields -time 0

# Solve Boussinesq equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

# Post processing

time=500000

./calcHMean.sh . $time
./graphs.sh $time

writeuvw -time $time u
gmtFoam -time $time ubw
gv $time/ubw.pdf &

# Calculate the Nusselt number for every time step
echo '#Time Nusselt0 NusseltTop' > Nusselt.dat
for time in [0-9]*; do
    echo -n $time ' ' >> Nusselt.dat
    ./calcHMean.sh . $time
    BoussinesqNusselt.sh hMeans $time | tail -1 >> Nusselt.dat
done
sort -g -k 1 Nusselt.dat | sponge Nusselt.dat

# Conditional average based on wb (units m^2/s^3)
# wb condition is Nusselt*alpha*Db/H (units m^2/s^3) = 25*3.16*7.07e-4/1e4 = 5.5853e-6
time=500000
writeuvw -time $time u
multiplyFields $time wb $time uz $time b
conditionalAverage3 -time $time stable up down wb 1e-5 uz 0

# Conditionally average b, P and u and horizontally average
# Multiply by sigma
for var in P b u; do
    for part in stable up down; do
        multiplyFields $time sigma$var.$part $time $var $time sigma.$part
    done
done

# Horizontally average
sed 's/TIME/'$time'/g' $case/hMeans/system/controlDictTIME \
    > $case/hMeans/system/controlDict
mapFields -case $case/hMeans $case -consistent -mapMethod cellVolumeWeight -sourceTime $time

# Divide by sigma
for var in P b u; do
    for part in stable up down; do
        multiplyFields -case hMeans $time $var.$part $time sigma$var.$part $time sigma.$part -pow1 -1
    done
done

# Write xyz cell data
for var in b u P sigma; do
    for part in stable up down; do
        writeCellDataxyz -case $case/hMeans -time $time $var.$part
        sort -g -k 3 $case/hMeans/$time/$var.$part.xyz \
            | sponge $case/hMeans/$time/$var.$part.xyz
    done
done

