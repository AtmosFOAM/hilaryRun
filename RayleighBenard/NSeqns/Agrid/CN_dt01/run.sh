#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# add Gaussian random noise to theta.stable
postProcess -func randomise -time 0
mv 0/theta 0/theta_init
mv 0/'randomise(theta)' 0/theta

decomposePar

# Solve Euler equations
mpirun -np 3 --use-hwthread-cpus exnerFoamA -parallel >& log & sleep 0.01; tail -f log

# calculate heat flux over last 10 secs of simulation
postProcess -func "grad(theta)" -time "60:"
writeCellDataxyz U -time "60:"
writeCellDataxyz theta -time "60:"
writeCellDataxyz "grad(theta)" -time "60:"
writeCellDataxyz p -time "60:"
writeCellDataxyz T -time "60:"
gedit calcHeatFlux.py &   # change domain geometry
python calcHeatFlux.py >& heatFlux.txt & sleep 0.01; tail -f heatFlux.txt

gmtPlot ../../plots/plotCo.gmt
gmtPlot ../../plots/plotEnergy.gmt

# Differences between partitions
time=100
for var in theta Uf; do
    sumFields $time $var.diff $time $var.stable $time $var.buoyant -scale1 -1
done
for var in theta ; do
    gmtFoam -time $time ${var}Diff
    evince $time/${var}Diff.pdf &
done

# More diagnostics
for var in sigmaTheta; do
    gmtFoam -time $time ${var}Zoom
    evince $time/${var}Zoom.pdf &
done

# Plot theta and sigma
for time in {0..100..2}; do
    gmtFoam sigmaTheta -time $time
    evince $time/sigmaTheta.pdf &
done

# animate the results
for field in sigmaTheta; do
    gmtFoam $field
    eps2gif $field.gif ?/$field.pdf ??/$field.pdf ???/$field.pdf
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

