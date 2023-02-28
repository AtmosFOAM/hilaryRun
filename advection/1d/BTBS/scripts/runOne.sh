#!/bin/bash -e

if [ "$#" -ne 4 ]; then
    echo usage 'runOne.sh caseRoot init|run|post nIter solver'
    exit
fi

caseRoot=$1
nIter=$3
solver=$4

case=${caseRoot}_it${nIter}_${solver}
echo $case

if [[ $2 == init  ]]; then
    rm -rf $case
    mkdir -p $case
    cp -r template/system $case
    cp -r template/0 $case
    # Mesh generation
    blockMesh -case $case
    
    sed -i 's/SOLVER/'$solver'/g;s/NITER/'$nIter'/g' $case/system/fvSolution

    # Initial conditions
    setInitialTracerField -case $case
    mv $case/0/T_analytic $case/0/T

#    ./scripts/plotT.sh $case 0
#    ev $case/0/T.eps

elif [[ $2 == run  ]]; then
    implicitAdvectionFoam -case $case | tee $case/log
    writeCellDataxyz -case $case -latestTime T
    for file in $case/*/T.xyz  ; do
        awk 'NR == 1 {print $0}; NR > 1 {print $0 | "sort -n -k1"}' \
            $file | sponge $file
    done
else
    # plot
    ./scripts/plotT.sh $case 0.1
    ev $case/0.1/T.eps
fi

