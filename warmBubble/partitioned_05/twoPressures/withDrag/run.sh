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

# Warm bubble only in the buoyant partition
mv 0/theta 0/theta.buoyant
cp init_0/theta 0/theta.stable
for var in Uf u Exner; do
    cp 0/$var 0/$var.stable
    cp 0/$var.stable 0/$var.buoyant
done
rm 0/thetaf

# create initial sigma field
setFields
sumFields 0 sigma.stable init_0 sigma.stable 0 sigma.buoyant -scale1 -1

# Plot initial conditions
time=0
gmtFoam sigmaTheta -time $time
gv $time/sigmaTheta.pdf &

# Solve Euler equations
multiFluidFoam_TwoPressures >& log & sleep 0.01; tail -f log

gmtPlot plots/plotCo.gmt
gmtPlot plots/plotEnergy.gmt

# Plot theta and sigma
# Plot theta and sigma
for time in 100 1000; do
    gmtFoam sigmaTheta -time $time
    gv $time/sigmaTheta.pdf &
done

# animate the results
for field in theta sigma; do
    gmtFoam $field
    eps2gif $field.gif 0/$field.pdf ???/$field.pdf ????/$field.pdf
done

# Make links for animategraphics
mkdir -p animategraphics
for field in sigmaTheta ; do
    t=0
    for time in [0-9] [0-9]?? [0-9]???; do
        ln -s ../$time/$field.pdf animategraphics/${field}_$t.pdf
        let t=$t+1
    done
done

