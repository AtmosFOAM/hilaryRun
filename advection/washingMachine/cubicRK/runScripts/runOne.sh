#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: runOne.sh case
   exit
fi

case=$1

# Create the case
if [[ ! -e $case ]]; then
    mkdir $case
    cp -r runScripts/constant runScripts/system $case
    gedit -s $case/system/* $case/constant/*Dict
fi
if [[ ! -e $case/0 ]]; then
    # Mesh generation
    blockMesh -case $case
    # Set up the initial conditions
    rm -rf $case/[0-9]*
    mkdir $case/0
    setTracerField -case $case
    setVelocityField -case $case
    mv $case/0/T_analytic $case/0/T
fi

# Run the case
RKImExAdvectionFoam -case $case |& tee $case/log

# Plot and calculate error norms
T=600
sumFields -case $case $T Terror $T T 0 T -scale1 -1
#gmtFoam -case $case -time $T Terror
#ev $case/$T/Terror.pdf
globalSum -case $case -time $T T
globalSum -case $case -time $T Terror
echo "#Time l1 l2 linf normMass normVar" > $case/errorNorms.dat
paste $case/globalSumTerror.dat $case/globalSumT.dat | tail -1 | \
    awk '{print $1, $2/$10, $3/$11, $4/$12, $5/$13, $6/$11}' \
    >> $case/errorNorms.dat
cat $case/errorNorms.dat

