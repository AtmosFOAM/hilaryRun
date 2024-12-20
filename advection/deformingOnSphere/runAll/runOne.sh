#!/bin/bash -e

usage() {
cat << EOF
usage 'runOne.sh case init|run|time [-e executableName]'
EOF
}

if [ "$#" -lt 2 ]; then
    usage
    exit
fi

case=$1
action=$2
shift 2

exe=implicitAdvectionFoam
while getopts "e:" opt || :; do
    case $opt in
        e) exe=$OPTARG; break ;;
        [?]) break;;
    esac
done

if [[ $action == init  ]]; then
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
        sed 's:SOURCECASE:'$case':g' $case/system/extrudeMeshDictTmp \
            > $case/system/extrudeMeshDict
        extrudeMesh -case $case
    elif [[ -a $case/constant/HRgrid ]]; then
        grid=`cat $case/constant/HRgrid`
        cp $HOME/f77/buckyball_griddata/grid$grid.out/patch.obj \
            $case/constant
        sed 's:SOURCECASE:'$case':g' $case/system/extrudeMeshDictTmp \
            > $case/system/extrudeMeshDict
        extrudeMesh -case $case
    elif [[ -a $case/constant/dualGrid ]]; then
        grid=`cat $case/constant/dualGrid`
        rm -rf $case/constant/polyMesh $case/[0-9]* $case/processor* \
               $case/constant/orthogonality $case/constant/dx \
               $case/constant/skewness
        cp -r $case/$grid/constant/polyMesh $case/constant
        polyDualMesh 90 -case $case -overwrite
        sed 's:SOURCECASE:'$case':g' $case/system/extrudeMeshDictTmp \
            >$case/system/extrudeMeshDict
        extrudeMesh -case $case
    fi
    sed -i 's/patch/wall/g' $case/constant/polyMesh/boundary

    # Initial conditions
    rm -rf $case/0
    cp -r $case/init_0 $case/0
    setTracers -case $case -name T
    setVelocityField -case $case

elif [[ $action == run  ]]; then
    rm -rf 0.* [1-9]* processor*/[0-9]*
    # Parallel decomposition and run
    #decomposePar -case $case -force
    #echo starting mpirun. Output in $case/log
    #mpirun -np 4 $exe -case $case -parallel >& $case/log &
    $exe -case $case >& log &
    echo tail -f $case/log
elif [[ $action < 6 ]]; then
    if [[ -a $case/processor0 ]]; then
        reconstructPar -case $case -time $action
    fi
    gmtFoam -case $case -time $action T
    ev $action/T.pdf
else
    if [[ -a $case/processor0 ]]; then
        rm -rf $case/2.5 $case/5
        reconstructPar -case $case
        rm -r $case/processor*
    fi
    #Find max dx for this grid
    if [[ ! -a $case/maxDx.dat ]]; then
        cellCentreDistances -case $case \
            | awk '{if (NF==1 && $1==$1+0) print $1*180/3.14159}' \
            | sort -nr | head -1 > $case/maxDx.dat
    fi
    #finalTime=`ls -1d $case/[0-9]* | sort -n | tail -n 1`
    #midTime=`ls -1d $case/[0-9]* | sort -n | tail -n 6 | head -1`
    #if [[ $finalTime != $case/5 ]]; then mv $finalTime $case/5; fi
    #if [[ $midTime != $case/2.5 ]]; then mv $midTime $case/2.5; fi
    $case/../../../runAll/plotBoundsOne.sh $case
    ev $case/TminMax.eps
    #gmtFoam -case $case -time 5 T
    #gmtFoam -case $case -time 2.5 T
    #ev $case/5/T.pdf &
    #ev $case/2.5/T.pdf &
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

