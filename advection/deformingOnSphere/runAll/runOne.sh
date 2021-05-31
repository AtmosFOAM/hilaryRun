#!/bin/bash -e

if [ "$#" -ne 2 ]; then
    echo usage runOne.sh case run|post
    exit
fi

case=$1

if [[ $2 == run  ]]; then
    # Mesh generation
    if [[ -a $case/constant/earthProperties ]]; then
        latLon=`grep nLat $case/constant/earthProperties | wc | \
             awk '{print $1}'`
        if [[ $latLon > 0 ]]; then
            sphPolarLatLonMesh -case $case
        fi
    elif [[ -a $case/system/blockMeshDict ]]; then
        blockMesh -case $case
        tanPoints -case $case
        extrudeMesh -case $case
    elif [[ -a $case/constant/HRgrid ]]; then
        grid=`cat $case/constant/HRgrid`
        cp $HOME/f77/buckyball_griddata/grid$grid.out/patch.obj \
            $case/constant
        extrudeMesh -case $case
    elif [[ -a $case/constant/dualGrid ]]; then
        grid=`cat $case/constant/dualGrid`
        rm -r $case/constant/polyMesh
        cp -r $case/$grid/constant/polyMesh $case/constant
        polyDualMesh 90 -case $case -overwrite
        extrudeMesh -case $case
    fi

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
    echo starting mpirun. Output in $case/log
    mpirun -np 4 implicitAdvectionFoam -case $case -parallel >& $case/log
    #implicitAdvectionFoam -case $case >& log &
    #tail -f log
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

