#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Initial conditions from ../mediumResHiTop_Ngrad/
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

FROM=../../mediumResHiTop_Ngrad/200000

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

# Initial stratification in the stratosphere
setInitialTracerField -name bBar -time 0 -tracerDict setbBarDict
mv 0/bBar constant

# Tropospheric cooling
setFields -time 0
mv 0/Q constant

# Solve Boussinesq equations
rm -rf [1-9]* core
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

