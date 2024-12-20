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

# Partition into stable and buoyant fluids
cp 0/theta 0/theta.buoyant
cp 0/theta.buoyant 0/theta.stable
cp 0/Uf 0/Uf.stable
cp 0/Uf.stable 0/Uf.buoyant
rm 0/thetaf

# Plot initial conditions
time=0
gmtFoam sigmaTheta -time $time
gv $time/sigmaTheta.pdf &

# Solve Euler equations
#partitionedExnerFoam >& log & sleep 0.01; tail -f log
partitionedExnerFoamAdv >& log & sleep 0.01; tail -f log

gmtPlot ../plots/plotCo.gmt
gmtPlot ../plots/plotEnergy.gmt

# Plot theta and sigma
for time in 100 1000; do
    gmtFoam sigmaTheta -time $time
    gv $time/sigmaTheta.pdf &
done

# animate the results
for field in  theta sigmaTheta; do
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

# Horizontal means
horizontalMean
for time in [0-9]*; do
    for var in theta; do
        sed 's/TIME/'$time'/g' plots/$var.gmt > plots/tmp.gmt
        gmtPlot plots/tmp.gmt
    done
    rm plots/tmp.gmt
done

