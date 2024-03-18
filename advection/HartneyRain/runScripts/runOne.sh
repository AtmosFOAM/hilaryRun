#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: runOne.sh case
   exit
fi

case=$1

# Resolutions:
# n=20, dt = 0.02
# n=40, dt = 0.01 for c = 0.8
# n=80, dt = 0.005
# n=160, dt = 0.0025

# Create the case
if [[ ! -e $case ]]; then
    mkdir -p $case/constant $case/system
    ln -s ../../runScripts/system/fvSchemes $case/system/fvSchemes
    ln -s ../../runScripts/system/fvSolution $case/system/fvSolution
    cp runScripts/system/*Dict $case/system
    cp -r runScripts/constant/T* runScripts/constant/gmtDicts $case/constant
    ln -s ../../runScripts/constant/fvModels $case/constant/fvModels
    ln -s ../../runScripts/constant/tracerFieldDict $case/constant/tracerFieldDict
    ln -s ../../runScripts/constant/velocityFieldDict \
        $case/constant/velocityFieldDict
    gedit -s $case/system/*Dict
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
    #gmtFoam -case $case -time 0 T
    #ev $case/0/T.pdf
fi

# Run the case
if [[ ! -e $case/1 ]]; then
    RKImExAdvectionFoam -case $case |& tee $case/log
fi

exit
if [[ -e $case/1 ]]; then
    # Plot and calculate error norms
    T=1
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
fi
