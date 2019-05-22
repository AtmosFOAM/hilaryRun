#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Stationary initial conditions with b from partitioned_identical
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

FROM=../partitioned_identical/sigmaUniform/0

values=`awk '{if(NR>1)print $4}' $FROM/horizontalMean_none_b.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/b.stable

# Solve multi-fluid Boussinesq equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

# plots of sigma and b
writeuvw u.stable
writeuvw u.buoyant
for var in u.buoyantz u.stablez b b.stable b.buoyant bt.stable bt.buoyant \
           sigma.buoyant Pi.stable Pi.buoyant massTransfer.buoyant.stable \
           massTransfer.stable.buoyant; do
    writeCellDataxyz $var
    for time in [0-9]*; do
        sort -g -k 3 $time/$var.xyz | sponge $time/$var.xyz
    done
done
for time in [0-9]*; do
    for var in w b sigma Pi S; do
        sed 's/TIME/'$time'/g' plots/$var.gmt > plots/tmp.gmt
        gmtPlot plots/tmp.gmt
    done
    rm plots/tmp.gmt
done

