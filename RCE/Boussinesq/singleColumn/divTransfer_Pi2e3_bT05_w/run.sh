#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0
mv 0/transferLocation constant

FROM=../../hiRes_wide/timeMean_w

values=`awk '{if(NR>1)print $2}' $FROM/none_sigma.stable.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/sigma.stable

values=`awk '{if(NR>1)print $2}' $FROM/none_sigma.buoyant.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/sigma.buoyant

values=`awk '{if(NR>1)print $2}' $FROM/sigma.stable_b.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/b.stable

values=`awk '{if(NR>1)print $2}' $FROM/sigma.buoyant_b.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/b.buoyant

values=`awk '{if(NR>1)print "("0, 0, $2")"}' $FROM/sigma.stable_uz.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/u.stable

values=`awk '{if(NR>1)print "("0, 0, $2")"}' $FROM/sigma.buoyant_uz.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/u.buoyant

values=`awk '{if(NR>1)print $2}' $FROM/dPdz.stable.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/dPdz.stable

values=`awk '{if(NR>1)print $2}' $FROM/dPdz.buoyant.dat | paste -s`
sed -i 's/REPLACE/'"$values"'/g' 0/dPdz.buoyant

# Solve Euler equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

