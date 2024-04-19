#!/bin/bash -e

res=320
# Gather data for each c and for each simulation type
for case in c05_exp  c05_imp  c1_imp  c2_imp  c4_imp \
         c1_impExp c2_impExp c4_impExp\
         c1_exp_upImp c2_exp_upImp c4_exp_upImp ; do
    dir=${res}x${res}/$case
    echo '#time Tmin Tmax TV' > $dir/TminMax.dat
    grep goes $dir/log | awk ' BEGIN { getline; TV1=$10 ; print $1, $5, $7, $10/TV1 } {print $1, $5, $7, $10/TV1}' >> $dir/TminMax.dat
done

# Plot minMax data
gmtPlot plots/minMax.gmt
gmtPlot plots/TV.gmt

