#!/bin/bash -e

if [ "$#" -ne 6 ]
then
   echo usage: initOne.sh case smooth\|slotted uniform\|deforming\|divergent \
                          dt nx withDensity\(true\|false\)
   exit
fi

case=$1
tracerType=$2
velocityType=$3
dt=$4
nx=$5
withDensity=$6

# Create the case
if [[ ! -e $case ]]; then
    mkdir -p $case/constant $case/system
    sed 's/NX/'$nx'/g' $case/../runScripts/system/blockMeshDict > $case/system/blockMeshDict
    sed 's/DT/'$dt'/g' $case/../runScripts/system/controlDict > $case/system/controlDict
    cp $case/../runScripts/system/fvSchemes $case/system/fvSchemes
    if [[ $withDensity == true ]]; then
        cp $case/../runScripts/system/fvSolutionWith $case/system/fvSolution
        cp $case/../runScripts/constant/rhoTracerDict $case/constant
    else
        cp $case/../runScripts/system/fvSolutionWithout $case/system/fvSolution
    fi
    
    cp -P $case/../runScripts/constant/gmtDicts $case/constant
    cp $case/../runScripts/constant/${tracerType}TracerDict $case/constant/tracerDict
    cp $case/../runScripts/constant/${velocityType}VelocityDict $case/constant/velocityDict
fi
if [[ ! -e $case/0 ]]; then
    # Mesh generation
    blockMesh -case $case
    # Set up the initial conditions
    rm -rf $case/[0-9]*
    mkdir $case/0
    setVelocityField -case $case -dict velocityDict
    if [[ $withDensity == true ]]; then
        setTracerField -case $case -name rho -tracerDict rhoTracerDict
    fi
    setTracerField -case $case -name T -tracerDict tracerDict
    rm $case/0/*f
    gmtFoam -case $case -time 0 UT
    gmtFoam -case $case -time 0 rhoU
    ev $case/0/*.pdf
fi

