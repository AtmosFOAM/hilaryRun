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
    #setFields -case $case
    ## Initial tracer field is 1/U
    #writeuvw -time 0 U -case $case
    #sed -i 's/\[0 1 -1 0 0 0 0\]/\[0 0 0 0 0 0 0]/g' $case/0/Ux
    #multiplyFields -case $case 0 T 0 T 0 Ux -pow1 -1

elif [[ $2 == run  ]]; then
    implicitAdvectionFoam -case $case >& log &
    tail -f log
else
#    # Plot variance over time
#    globalSum -case $case T
#    gmtPlot $case/plotVariance.gmt

    # Plot initial and final conditions
    times=`ls -d [0-9]* | sort -n`
    for time in $times; do
        ./plotUT.sh $case $time
    done
    evince 1.6/UT.eps 5/UT.eps &
    files=''
    for t in $times; do files="$files $t/UT.eps"; done
    eps2gif UT.gif $files
fi

