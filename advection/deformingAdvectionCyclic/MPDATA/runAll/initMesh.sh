#!/bin/bash -e
# Set up a test case either orthogonal or non-orthogonal with a given resolution
# without a specific time-step

if [ "$#" -ne 2 ]
then
   echo usage: initMesh.sh orthogonal'|'nonOrthog nx
   echo returns name of the mesh direcory
   exit
fi

type=$1
let nx=$2*2
ny=$2
case=${type}/${nx}x${ny}
dt=1

# derived properties
# number of grid points in half of the domain
let NX=$nx/2
let NY=$ny/2
SQUEEZE=1
EXPAND=1
AM=0
AP=0
if [ "$type" == "nonOrthog" ]; then
    SQUEEZE=0.5
    EXPAND=2
    AM=-0.144337567
    AP=0.144337567
elif [ "$type" != "orthogonal" ]; then
    echo in initMesh.sh 'type<orthogonal|nonOrthog>' nx 1>&2
    echo type must be one of orthogonal or nonOrthog, not $type 1>&2
    exit 1
fi

# Generate the case for a mesh on the sphere with the correct time-step
if [[ ! -f $case/constant/polyMesh/points ]]; then
    mkdir -p $case
    rm -rf $case/constant $case/system
    cp -r dummy/system dummy/constant $case
    sed -i -e 's/NX/'$NX'/g' -e 's/NY/'$NY'/g' -e 's/AM/'$AM'/g' \
        -e 's/AP/'$AP'/g' -e 's/SQUEEZE/'$SQUEEZE'/g' -e 's/EXPAND/'$EXPAND'/g'\
        $case/system/blockMeshDict
    sed -e 's/DELTAT/0/g' dummy/system/controlDict > $case/system/controlDict

    # Generate the mesh on a plane
    blockMesh -case $case > $case/meshLog

    # link to the gmtDicts directory
    ln -s ../../../gmtDicts $case/constant/gmtDicts
fi

echo $case

