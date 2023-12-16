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
    setTracerField -tracerDict tracerFieldDict1 -case $case
    mv $case/0/T_analytic $case/0/T1
    setTracerField -tracerDict tracerFieldDict2 -case $case
    mv $case/0/T_analytic $case/0/T2
    sumFields -case $case 0 T 0 T1 o T2

    ./scripts/plotT.sh $case 0
    ev $case/0/T.eps

elif [[ $2 == run  ]]; then
    implicitAdvectionFoam -case $case | tee $case/log
else
    # plot
    for time in [0-9]*; do
        ./scripts/plotT.sh $case $time
    done
    eps2gif T.gif `ls */T.eps | sort -n`
    ffmpeg  -i  T.gif  T.mp4
    totem T.mp4
fi

