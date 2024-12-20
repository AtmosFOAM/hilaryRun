#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# hydrostatically balanced initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0
setExnerBalancedH

# Add a warm perturnation
cp 0/theta constant/theta_init
cp 0/theta 0/theta_init
makeHotBubble
rm 0/thetaf

# Plot initial theta
time=0
gmtFoam theta -time $time
gv $time/theta.pdf &

# Solve Euler equations
exnerFoamTurbulence >& log & sleep 0.01; tail -f log

# Debugging diagnostics
time=100
for var in nut k epsilon theta; do
    gmtFoam -time $time $var
    gv $time/$var.pdf &
done

