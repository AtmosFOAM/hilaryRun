#!/bin/bash -e

if [ "$#" -ne 2 ]; then
    echo usage 'runOne.sh case init|run|post'
    exit
fi

case=$1

if [[ $2 == init  ]]; then
    # Mesh generation
    blockMesh -case $case

    # Initial conditions
    rm -rf $case/0
    cp -r $case/init_0 $case/0
    #setVelocityField -case $case
    setFields -case $case
    # Initial tracer field is 1/U
    writeuvw -time 0 U -case $case
    sed -i 's/\[0 1 -1 0 0 0 0\]/\[0 0 0 0 0 0 0]/g' $case/0/Ux
    multiplyFields -case $case 0 T 0 T 0 Ux -pow1 -1

elif [[ $2 == run  ]]; then
    implicitAdvectionFoam -case $case >& log &
    tail -f log
else
    # Plot initial and final conditions
    ./plotUT.sh $case 0
    ./plotUT.sh $case 80
    ./plotUT.sh $case 90
    ./plotUT.sh $case 100
fi

