#!/bin/bash -e

# Calculate horizontal means conditioned on vertical velocity and plot

time=200000
writeuvw u -time $time

# Create cell sets "rising" and "falling" dependent on w
topoSet -dict system/conditionalSamplingDict -time $time

# Redefine sigma based on w
setFields -dict system/conditionalSamplingDict -noFunctionObjects

# Horizontal mean based on new sigma
horizontalMean -time $time

# Write out mean plus/minus one standard deviation of P, b and w
for var in b uz P; do for fluid in none sigma.stable sigma.buoyant; do
    awk '{print $1, $2, $3, $4, $4-$5, $4+$5, $6, $7}' \
        $time/horizontalMean_${fluid}_${var}.dat \
        | sponge $time/horizontalMean_${fluid}_${var}.dat
done; done

# Calculate dpdz
for part in stable buoyant; do
    sed -e "1d" $time/horizontalMean_sigma.${part}_P.dat | \
        awk 'BEGIN { z0=0; P0=0 }
             { print 0.5*($1+z0), ($4-P0)/($1-z0); P0=$4; z0=$1}' \
        > $time/horizontalMean_dPdz.${part}.dat
done

# plots
for var in b w sigma P dPdz; do
    sed 's/TIME/'$time'/g' plots/$var.gmt > plots/tmp.gmt; \
    gmtPlot plots/tmp.gmt
done
rm plots/tmp.gmt


