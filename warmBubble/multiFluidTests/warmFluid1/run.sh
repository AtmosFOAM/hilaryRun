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

# Add a warm perturnation to fluid 1 only
cp 0/theta 0/theta_init
cp 0/theta constant/theta_init
makeHotBubble
cp 0/theta 0/theta.buoyant
cp 0/theta_init 0/theta.stable

# Partition into stable and buoyant fluids
mv 0/u 0/u.stable
mv 0/Uf 0/Uf.stable
cp 0/u.stable 0/u.buoyant
cp 0/Uf.stable 0/Uf.buoyant
rm 0/thetaf

# create initial conditions for sigma
setFields
sumFields 0 sigma.stable init_0 sigma.stable 0 sigma.buoyant -scale1 -1

# Plot initial conditions
time=0
gmtFoam sigmaTheta -time $time
gv $time/sigmaTheta.pdf &

# Solve Euler equations
multiFluidFoam >& log & sleep 0.01; tail -f log

# Plot theta and sigma
time=770
for field in sigma theta_stable theta_buoyant ; do
    gmtFoam $field -time $time
    gv $time/$field.pdf &
done

# animate the results
for field in sigma theta_stable theta_buoyant ; do
    gmtFoam $field
    eps2gif $field.gif 0/$field.pdf ??/$field.pdf ???/$field.pdf ????/$field.pdf
done

# Make links for animategraphics
mkdir -p animategraphics
for field in sigma theta_stable theta_buoyant; do
    t=0
    for time in [0-9] [0-9]? [0-9]?? [0-9]???; do
        ln -s ../$time/$field.pdf animategraphics/${field}_$t.pdf
        let t=$t+1
    done
done

