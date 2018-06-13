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

# change Exner BC from fixedValue to hydroStaticExner
sed -i 's/fixedFluxBuoyantExner/partitionedHydrostaticExner/g' 0/Exner

# Add a warm perturnation
cp 0/theta 0/theta_init
makeHotBubble

# Warm bubble only in the buoyant partition
mv 0/theta 0/theta.buoyant
cp init_0/theta 0/theta.stable
mv 0/Uf 0/Uf.stable
cp 0/Uf.stable 0/Uf.buoyant
mv 0/u 0/u.stable
cp 0/u.stable 0/u.buoyant
rm 0/thetaf
mv 0/alphat 0/alphat.stable; cp 0/alphat.stable 0/alphat.buoyant
mv 0/nut 0/nut.stable; cp 0/nut.stable 0/nut.buoyant
mv 0/k 0/k.stable; cp 0/k.stable 0/k.buoyant
mv 0/epsilon 0/epsilon.stable; cp 0/epsilon.stable 0/epsilon.buoyant

# create initial sigma field
setFields
sumFields 0 sigma.stable init_0 sigma.stable 0 sigma.buoyant -scale1 -1

# Plot initial conditions
time=0
gmtFoam sigmaTheta -time $time
gv $time/sigmaTheta.pdf &

# Solve Euler equations
partitionedTurbulentFoam >& log & sleep 0.01; tail -f log

gmtPlot ../../plots/plotCo.gmt
gmtPlot ../../plots/plotEnergy.gmt

# Debugging diagnostics
for var in k epsilon; do
    gmtFoam -time $time $var
    gv $time/$var.pdf &
done

# Plot theta and sigma
for time in 100 1000; do
    gmtFoam sigmaTheta -time $time
    gv $time/sigmaTheta.pdf &
done

# animate the results
for field in sigmaTheta; do
    gmtFoam $field
    eps2gif $field.gif 0/$field.pdf ???/$field.pdf ????/$field.pdf
done

# Make links for animategraphics
mkdir -p animategraphics
for field in theta sigma; do
    t=0
    for time in [0-9] [0-9]?? [0-9]???; do
        ln -s ../$time/$field.pdf animategraphics/${field}_$t.pdf
        let t=$t+1
    done
done

