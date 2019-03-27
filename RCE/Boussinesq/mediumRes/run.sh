#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Initial buoyancy perturbations and transfer at the ground
setFields

# Solve Euler equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

# Plots
writeuvw u

for var in b w; do
    gmtFoam $var
    eps2gif $var.gif 0/$var.pdf ????/$var.pdf ?????/$var.pdf ??????/$var.pdf
done


# Plot cooling rate, Q
grep value */Q | awk -F'/' '{print $1, $2}' | awk '{print $1, $3}' \
     | awk -F';' '{print $1}'| sort -n > plots/Q.dat
gmtPlot plots/Q.gmt

