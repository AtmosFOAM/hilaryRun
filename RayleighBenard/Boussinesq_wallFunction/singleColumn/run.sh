#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Initial buoyancy perturbations and transfer at the walls
setFields

# Solve Euler equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

# Plot all fields
for time in [0-9]*; do
    for field in sigma b b.stable b.buoyant S01 S10; do
        gmtFoam -time $time $field
    done
    sed 's/TIMEDIR/'$time'/g' plots/plotFields.tex > plotFields.tex; \
        pdflatex plotFields.tex; \
        pdfcrop plotFields.pdf $time/plotFields.pdf; \
        rm plotFields.*
done
eps2gif allFields.gif 0/plotFields.pdf ?/plotFields.pdf ??/plotFields.pdf \
        ???/plotFields.pdf

