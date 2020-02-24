#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Non-uniform surface buoyancy flux
postProcess -func nonUniformSST

# Solve Euler equations
boussinesqFoam >& log & sleep 0.01; tail -f log

time=15000
gmtFoam b -time $time':'
eps2gif b.gif `ls */b.pdf | sort -n`

