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
cp 0/theta constant/theta_init
cp 0/theta 0/theta_init
makeHotBubble

# Warm bubble in both partitions
cp 0/theta 0/theta.buoyant
mv 0/theta 0/theta.stable
for var in Uf u alphat nut k epsilon; do
    cp init_0/$var 0/$var.buoyant
    cp init_0/$var 0/$var.stable
    rm -f 0/$var
done
rm 0/thetaf

# create initial sigma field
#setFields
sumFields 0 sigma.stable init_0 sigma.stable 0 sigma.buoyant -scale1 -1

# Plot initial conditions
time=0
gmtFoam sigmaTheta -time $time
gv $time/sigmaTheta.pdf &

# Solve Euler equations
partitionedTurbulentFoam >& log & sleep 0.01; tail -f log

gmtPlot ../../plots/plotCo.gmt
gmtPlot ../../plots/plotEnergy.gmt

# Differences between partitions
time=1000
for var in k epsilon Uf; do
    sumFields $time $var.diff $time $var.stable $time $var.buoyant -scale1 -1
done
for var in k epsilon; do
    gmtFoam -time $time ${var}Diff
    gv $time/${var}Diff.pdf &
done

# More diagnostics
for var in sigmaTheta k epsilon; do
    gmtFoam -time $time $var
    gv $time/$var.pdf &
done

# Plot theta and sigma
time=1000
for var in k sigmaTheta; do
    gmtFoam $var -time $time
    gv $time/$var.pdf &
done

# animate the results
for var in k sigmaTheta; do
    gmtFoam $var
    eps2gif $var.gif 0/$var.pdf ???/$var.pdf ????/$var.pdf
done

# Make links for animategraphics
mkdir -p animategraphics
for field in k_stable ; do
    t=0
    for time in [0-9] [0-9]?? [0-9]???; do
        ln -s ../$time/$field.pdf animategraphics/${field}_$t.pdf
        let t=$t+1
    done
done

