#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: runOne.sh case
   exit
fi

export case=$1

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
    cp -r runScripts/constant/T* runScripts/constant/rain \
         runScripts/constant/gmtDicts $case/constant
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
    cp $case/0/T_analytic $case/0/T
    cp $case/constant/rain $case/0
    #gmtFoam -case $case -time 0 T
    #ev $case/0/T.pdf
fi

# Run the case
if [[ ! -e $case/1 ]]; then
    RKImExAdvectionFoam -case $case |& tee $case/log
fi

if [[ -e $case/1 ]]; then
    for t in 1; do
        export t=$t
        # Plot the vapour and the rain
        for var in rain qsat T; do
            writeCellDataxyz -case $case -time $t $var
        done
        gmtPlot $case/../runScripts/rain.gmt
        ev $case/$t/rain.eps
    done
    #eps2gif $case/rain.gif $case/0/rain.eps $case/0.*/rain.eps $case/1/rain.eps
fi
