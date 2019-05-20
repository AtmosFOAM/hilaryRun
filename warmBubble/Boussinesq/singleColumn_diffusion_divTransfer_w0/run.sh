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

values=`awk '{if(NR>1)print $4*5}' $FROM/horizontalMean_none_b.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/b.buoyant

# Solve multi-fluid Boussinesq equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

# plots of sigma and b
writeuvw u.stable
writeuvw u.buoyant
writeCellDataxyz u.buoyantz
writeCellDataxyz u.stablez
writeCellDataxyz b
writeCellDataxyz sigma.buoyant
writeCellDataxyz divu.stable
writeCellDataxyz divu.buoyant
writeCellDataxyz Pi.stable
writeCellDataxyz Pi.buoyant
for time in [0-9]*; do
    sort -g -k 3 $time/b.xyz | sponge $time/b.xyz
    sort -g -k 3 $time/sigma.buoyant.xyz | sponge $time/sigma.buoyant.xyz
    sort -g -k 3 $time/divu.stable.xyz | sponge $time/divu.stable.xyz
    sort -g -k 3 $time/divu.buoyant.xyz | sponge $time/divu.buoyant.xyz
    sort -g -k 3 $time/u.stablez.xyz | sponge $time/u.stablez.xyz
    sort -g -k 3 $time/u.buoyantz.xyz | sponge $time/u.buoyantz.xyz
    sort -g -k 3 $time/Pi.stable.xyz | sponge $time/Pi.stable.xyz
    sort -g -k 3 $time/Pi.buoyant.xyz | sponge $time/Pi.buoyant.xyz
    for var in w b sigma divu Pi; do
        sed 's/TIME/'$time'/g' plots/$var.gmt > plots/tmp.gmt
        gmtPlot plots/tmp.gmt
    done
    rm plots/tmp.gmt
done

