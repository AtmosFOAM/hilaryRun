#!/bin/bash -e

# Calculate horizontal means conditioned on vertical velocity and plot

time=200000
# Create cell sets "rising" and "falling" dependent on w
writeuvw u -time $time
topoSet -dict system/conditionalSamplingDict -time $time

# Conditioanl horizontal means of b and w
horizontalMean -time $time -cellSet rising
horizontalMean -time $time -cellSet falling
horizontalMean -time $time

# Write out mean plus/minus one standard deviation of b and w
for var in b uz P; do for set in rising falling; do
    awk '{print $1, $2, $3, $4, $4-$5, $4+$5, $6, $7}' \
        $time/horizontalMean_${set}_${var}.dat \
        | sponge $time/horizontalMean_${set}_${var}.dat
done; done

# plots
for var in b w sigma P; do
    sed 's/TIME/'$time'/g' plots/$var.gmt > plots/tmp.gmt
    gmtPlot plots/tmp.gmt
done
rm plots/tmp.gmt

# Redefine sigma based on w
setFields -dict system/conditionalSamplingDict -noFunctionObjects

# Rerun for one time step and average onto a coarse grid
multiFluidBoussinesqFoam
