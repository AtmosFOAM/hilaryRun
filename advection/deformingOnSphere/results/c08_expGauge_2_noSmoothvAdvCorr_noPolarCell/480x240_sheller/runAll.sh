#!/bin/bash -e

if [ "$#" -ne 1 ]; then
    echo usage runAll.sh run|post
    exit
fi

case=.

if [[ $1 == run ]]; then
    # Mesh generation
    sphPolarLatLonMesh -case $case

    # Initial conditions
    rm -rf $case/0
    cp -r $case/init_0 $case/0
    setInitialTracerField -case $case -name T
    sed -i 's/calculated/zeroGradient/g' $case/0/T
    setVelocityField -case $case
    #gmtFoam -case $case -time 0 UT
    #gv $case/0/UT.pdf &

    # Parallel decomposition
    decomposePar -case $case

    mpirun -np 4 implicitAdvectionFoam -case $case -parallel >& log &
    tail -f log
else
    # Errors from initial conditions
    sumFields -case $case 5 Terror 5 T 0 T -scale1 -1
    globalSum -case $case T -time 0
    mv $case/globalSumT.dat $case/globalSumT0.dat
    globalSum -case $case T -time 5
    globalSum -case $case Terror -time 5

    echo '#l1 l2 linf mean var min max' > $case/errorNorms.dat
    paste $case/globalSumTerror.dat $case/globalSumT0.dat \
          $case/globalSumT.dat | tail -1 |\
        awk '{print $2/$10, $3/$11, $4/$12, $5/$13, $6/$14, $23, $24}' \
        >> $case/errorNorms.dat
    cat $case/errorNorms.dat
fi

