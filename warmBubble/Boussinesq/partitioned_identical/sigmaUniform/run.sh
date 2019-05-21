#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Stationary initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Add a buoyant perturbation
setInitialTracerField -name b.buoyant -tracerDict setbDict
setInitialTracerField -name b.stable -tracerDict setbDict
setInitialTracerField -name b -tracerDict setbDict

#sumFields 0 stable.sigma init_0 stable.sigma 0 buoyant.sigma -scale1 -1

# Plot initial conditions
time=0
gmtFoam sigmab -time $time
gv $time/sigmab.pdf &

# Solve multi-fluid Boussinesq equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

# Calculate conditional horizontal means of b
for time in [1-9]*; do
    writeuvw u -time $time
    # Redefine sigma based on w
    topoSet -dict system/conditionalSamplingDict -time $time
    /home/hilary/OpenFOAM/hilary-dev/platforms/linux64GccDPInt32Opt/bin/setFields -dict system/conditionalSamplingDict -noFunctionObjects \
        -time $time

    horizontalMean -time $time

    # Write out mean plus/minus one standard deviation of P, b and w
    for var in b uz P; do for fluid in none sigma.stable sigma.buoyant; do
        awk '{print $1, $2, $3, $4, $4-$5, $4+$5, $6, $7}' \
            $time/horizontalMean_${fluid}_${var}.dat \
            | sponge $time/horizontalMean_${fluid}_${var}.dat
    done; done
    
    # Pressure differences from horizontal mean
    for fl in stable buoyant; do
        paste $time/horizontalMean_sigma.${fl}_P.dat \
              $time/horizontalMean_none_P.dat | \
              awk '{print $1, $2, $3, $4 - $12, $5, $6, $7, $8}' |\
              sponge $time/horizontalMean_sigma.${fl}_P.dat
    done

    # plots
    for var in b01 P01 sigma b w P; do
        sed 's/TIME/'$time'/g' plots/$var.gmt > plots/tmp.gmt
        gmtPlot plots/tmp.gmt
    done
    rm plots/tmp.gmt
done

# horizontal mean of just b and sigma at time 0
horizontalMean -dict system/horizontalMean0Dict -time 0
cp 0/horizontalMean_none_b.stable.dat 0/horizontalMean_none_b.dat

eps2gif b.gif 0/b.pdf ??/b.pdf ???/b.pdf ????/b.pdf

