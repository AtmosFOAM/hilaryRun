#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Initial buoyancy perturbations and transfer at the ground
setFields
cp 0/transferLocation constant

# Solve Euler equations
rm -rf [1-9]* core
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

# Create ascii data files of all fields
for field in sigma.buoyant b b.stable b.buoyant Uf Uf.buoyant Uf.stable \
         massTransfer.buoyant.stable massTransfer.stable.buoyant; do
    writeCellDataxyz $field
    
   for time in [0-9]*; do
       grep 100000 $time/$field.xyz | grep 500 | sort -g -k 3 > $time/$field.xyzSorted
       mv $time/$field.xyzSorted $time/$field.xyz
    done
done

# Graphs of all fields
times=`ls -d [0-9]* | sort -g`
for time in $times; do
    for field in sigma b u massTransfer; do
        sed 's/TIME/'$time'/g' plots/$field.gmt > plots/tmp.gmt; \
        gmtPlot plots/tmp.gmt
        eps2png $time/$field.eps
    done
    montage $time/sigma.png $time/massTransfer.png $time/b.png $time/u.png \
            -tile 4x1 -geometry +0+0 $time/results.png
    eog -w $time/results.png &
done
convert ?/results.png ???/results.png ????/results.png ?????/results.png \
         results.gif
animate results.gif &

