#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Initial conditions from ../mediumRes/
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

FROM=../mediumRes/200000

values=`awk '{if(NR>1)print $4}' $FROM/horizontalMean_none_sigma.stable.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/sigma.stable

values=`awk '{if(NR>1)print $4}' $FROM/horizontalMean_none_sigma.buoyant.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/sigma.buoyant

values=`awk '{if(NR>1)print $4}' $FROM/horizontalMean_sigma.stable_b.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/b.stable

values=`awk '{if(NR>1)print $4}' $FROM/horizontalMean_sigma.buoyant_b.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/b.buoyant

values=`awk '{if(NR>1)print "("0, 0, $4")"}' $FROM/horizontalMean_sigma.stable_uz.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/u.stable

values=`awk '{if(NR>1)print "("0, 0, $4")"}' $FROM/horizontalMean_sigma.buoyant_uz.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/u.buoyant

# Initial buoyancy perturbations and transfer at the ground
#setFields

# Transfers everywhere to keep sigma uniform
mv 0/transferLocation constant

# Solve Boussinesq equations
rm -rf [1-9]* core
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

# Plot cooling rate, Q
grep value [0-9]*/Q | awk -F'/' '{print $1, $2}' | awk '{print $1, $3}' \
     | awk -F';' '{print $1}'| sort -n > plots/Q.dat
gmtPlot plots/Q.gmt

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

