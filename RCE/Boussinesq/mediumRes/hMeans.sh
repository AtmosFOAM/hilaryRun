#!/bin/bash -e

# Calculate horizontal means conditioned on vertical velocity and plot

time=200000
# Create cell sets "rising" and "falling" dependent on w
writeuvw u -time $time
topoSet -dict system/conditionalSamplingDict -time $time

# Conditioanl horizontal means of b and w
horizontalMean -time $time -cellSet rising
horizontalMean -time $time -cellSet falling

# Write out mean plus/minus one standard deviation of b and w
awk '{print $1, $2, $3, $4, $4-$5, $4+$5, $6, $7}' \
    $time/horizontalMean_rising_b.dat \
    | sponge $time/horizontalMean_rising_b.dat
awk '{print $1, $2, $3, $4, $4-$5, $4+$5, $6, $7}' \
    $time/horizontalMean_falling_b.dat \
    | sponge $time/horizontalMean_falling_b.dat
awk '{print $1, $2, $3, $4, $4-$5, $4+$5, $6, $7}' \
    $time/horizontalMean_rising_uz.dat \
    | sponge $time/horizontalMean_rising_uz.dat
awk '{print $1, $2, $3, $4, $4-$5, $4+$5, $6, $7}' \
    $time/horizontalMean_falling_uz.dat \
    | sponge $time/horizontalMean_falling_uz.dat
    
# plots
for var in b w sigma; do
    sed 's/TIME/'$time'/g' plots/$var.gmt > plots/tmp.gmt
    gmtPlot plots/tmp.gmt
done
rm plots/tmp.gmt

