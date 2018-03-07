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

# Identical stable and buoyant partitions
mv 0/theta 0/buoyant.theta
cp 0/buoyant.theta 0/stable.theta
mv 0/Uf 0/stable.Uf
cp 0/stable.Uf 0/buoyant.Uf
rm 0/thetaf

# create initial sigma field
setFields
sumFields 0 stable.sigma init_0 stable.sigma 0 buoyant.sigma -scale1 -1

# Plot initial conditions
time=0
gmtFoam sigmaTheta -time $time
gv $time/sigmaTheta.pdf &

# Solve Euler equations
#partitionedExnerFoam >& log & sleep 0.01; tail -f log
partitionedExnerFoamAdv >& log & sleep 0.01; tail -f log

gmtPlot ../../plots/plotEnergy.gmt
gmtPlot ../../plots/plotCo.gmt

# Plot theta and sigma
for time in 100 1000; do
    gmtFoam sigmaTheta -time $time
    gv $time/sigmaTheta.pdf &
done

# animate the results
#for field in theta sigma; do
for field in sigmaTheta ; do
    gmtFoam $field
    eps2gif $field.gif 0/$field.pdf ???/$field.pdf ????/$field.pdf
done

# Make links for animategraphics
mkdir -p animategraphics
#for field in theta sigma; do
for field in sigmaTheta ; do
    t=0
    for time in [0-9] [0-9]?? [0-9]???; do
        ln -s ../$time/$field.pdf animategraphics/${field}_$t.pdf
        let t=$t+1
    done
done


# Debugging - differences from warmBubble/advective case
time=2
for part in stable buoyant sum; do
    for field in Uf theta rho; do
        sumFields $time ${part}.${field}Diff $time $part.$field \
                   ../../advective/$time $part.$field -scale1 -1
    done
done
sumFields $time ExnerDiff $time Exner ../../advective/$time Exner -scale1 -1
gmtFoam -time $time ExnerDiff
gv $time/ExnerDiff.pdf &

gmtFoam -time $time rhoDiff
gmtFoam -time $time thetaDiff
gv $time/rhoDiff.pdf &
gv $time/thetaDiff.pdf &

time=100
sumFields $time rhoDiff $time sum.rho $time sum.sigma.rho -scale1 -1

