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

exe=RKImExAdvectionFoam
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
    setTerminator -case $case
    mv $case/0/Xsum $case/0/Tsum
    setVelocityField -case $case
    gmtFoam -case $case -time constant k1
    evince $case/constant/k1.pdf &

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
    gmtFoam -case $case -time $action X
    ev $case/$action/X.pdf
    sumFields -case $case $action TsumError $action Tsum 0 Tsum -scale0 1e6 -scale1 -1e6
    gmtFoam -case $case -time $action Tsum
    ev $case/$action/Tsum.pdf
fi

