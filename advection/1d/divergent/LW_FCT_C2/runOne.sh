#!/bin/bash -e

if [ "$#" -ne 2 ]; then
    echo usage 'runOne.sh case init|run|post'
    exit
fi

case=$1

if [[ $2 == init  ]]; then
    rm -rf [0-9]* constant/polyMesh
    # Mesh generation
    blockMesh -case $case

    # Initial conditions
    rm -rf $case/0
    cp -r $case/init_0 $case/0
    setVelocityField -case $case -dict velocityDict
    ./plotUT.sh $case 0
    ev $case/0/UT.eps

elif [[ $2 == run  ]]; then
    implicitAdvectionFoam -case $case >& log &
    tail -f log
else
#    # Plot variance over time
#    globalSum -case $case T
#    gmtPlot $case/plotVariance.gmt

    # Plot initial and final conditions
    for time in 1.6 3.6 5; do
        ./plotUT.sh $case $time
    done
    evince 1.6/UT.eps 3.6/UT.eps 5/UT.eps &
    times=`ls -d [0-9]* | sort -n`
    for time in $times; do
        ./plotUT.sh $case $time
    done
    files=''
    for t in $times; do files="$files $t/UT.eps"; done
    eps2gif UT.gif $files
fi

