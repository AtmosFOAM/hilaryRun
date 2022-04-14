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
    setInitialTracerField -case $case
    mv 0/T_analytic 0/T

    $case/../../scripts/plotTc.sh $case 0
    ev $case/0/Tc.eps

elif [[ $2 == run  ]]; then
    implicitAdvectionFoam -case $case | tee $case/log
else
    # Calculate l2 norm
    sumFields -case $case 1 Terror 0 T 1 T -scale0 -1
    globalSum -case $case -time 0 T
    globalSum -case $case -time 1 Terror
    paste $case/globalSumTerror.dat $case/globalSumT.dat \
        | awk '{if ($1==1*$1) print $1, $2/$10, $3/$11, $4/$12; 
                else print $1, $2, $3, $4}' > $case/errorNorms.dat
    more $case/errorNorms.dat

    # plot
    $case/../../scripts/plotTc01.sh $case
    ev $case/1/Tc01.eps

#    times=`ls -d [0-9]* | sort -n`
#    for time in $times; do
#        $case/../../scripts/plotTc.sh $case $time
#    done
#    files=''
#    for t in $times; do files="$files $t/Tc.eps"; done
#    eps2gif Tc.gif $files
fi

