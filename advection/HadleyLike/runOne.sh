#!/bin/bash -e

if [ "$#" -ne 2 ]; then
    echo usage 'runOne.sh case init|run|postTime'
    exit
fi

# Hadley like circulations of KUJ14 "DCMIP tracer tests"
# Dynamical core model intercomparison project: Tracer transport test cases 
# James Kent, Paul A. Ullrich and Christiane Jablonowski

case=$1

if [[ $2 == init  ]]; then
    rm -rf processor* [0-9]* constant/polyMesh

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
    cp -r $case/../../init_0 $case/0
    setTracerFieldSphere -case $case -time 0 -name T -velocityDict none
    setTracerFieldSphere -case $case -time 0 -name rho -tracerDict rhoDict \
        -velocityDict none
    setVelocityFieldSphere -case $case -time 0

    # Plots of initial conditions
    writeuvwLatLon -case $case -time 0 U
    # Extract lat-z cross section of w
    awk 'function abs(v) { return v < 0 ? -v : v};
             {if (abs($1 - 180) < 1) {print $2, $3/1000, $6}}' \
             $case/0/U.latLon > $case/0/w.latz
    for var in T rho; do
        writeCellDataLatLon -time 0 -case $case $var
        # Exctract lat-z cross section
        awk 'function abs(v) { return v < 0 ? -v : v};
             {if (abs($1 - 180) < 1) {print $2, $3/1000, $4}}' \
             $case/0/$var.latLon > $case/0/$var.latz
    done
    gmt makecpt -C$GMTU/colours/wh-bl-gr-ye-re.cpt -D -T0.5/1.2/0.05 \
        > colourScale.cpt
    gmt pscontour $case/0/rho.latz -CcolourScale.cpt \
       -Ba30/a5 -JX18c/6c -R-90/90/0/12 -h0 -I  > $case/0/rho.eps
     
    gmt makecpt -C$GMTU/colours/wh-bl-gr-ye-re.cpt -D -T0/0.95/0.025 \
        > colourScale.cpt
    gmt pscontour $case/0/T.latz -CcolourScale.cpt \
       -Ba30/a5 -JX18c/6c -R-90/90/0/12 -h0 -I  > $case/0/T.eps

    gmt makecpt -C$GMTU/colours/red_white_blue.cpt -D -T-0.31/0.31/0.02 \
        > colourScale.cpt
    gmt pscontour $case/0/w.latz -CcolourScale.cpt \
       -Ba30/a5 -JX18c/6c -R-90/90/0/12 -h0 -I  > $case/0/w.eps
    makebb $case/0/*.eps
    ev $case/0/*.eps

    # Parallel decomposition
    decomposePar -case $case

elif [[ $2 == run  ]]; then
    if [[ -a $case/processor0 ]]; then
        mpirun -np 4 --use-hwthread-cpus ImExAdvectionFoam -case $case -parallel >& $case/log &
    else
        ImExAdvectionFoam -case $case >& log &
    fi
    echo tail -f $case/log
else
    time=$2
    if [[ -a $case/processor0/$time ]]; then
        reconstructPar -case $case -time $time
        rm -r $case/processor*/$time
    fi
    #time=`ls -1 $case | sort -n | tail -n 1`
    
    plotLatZ $case $time T 180 1 $GMTU/colours/wh-bl-gr-ye-re.cpt 0 0.95 0.025
    
fi


