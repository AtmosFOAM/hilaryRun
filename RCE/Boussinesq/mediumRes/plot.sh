#!/bin/bash -e

# Plots
writeuvw u

for var in b UP; do
    gmtFoam $var
    eps2gif $var.gif 0/$var.pdf ????/$var.pdf ?????/$var.pdf ??????/$var.pdf
done


# Plot cooling rate, Q
grep value */Q | awk -F'/' '{print $1, $2}' | awk '{print $1, $3}' \
     | awk -F';' '{print $1}'| sort -n > plots/Q.dat
gmtPlot plots/Q.gmt

