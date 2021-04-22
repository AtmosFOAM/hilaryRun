#!/bin/bash -e

#if [ "$#" -ne 0 ]; then
#    echo usage runAll.sh
#    exit
#fi

cs=(0.8 1.6 8)
cText="08 1p6 8"
echo $cText

schemes=("MPDATA_CN" "upwind")
echo ${schemes[*]}

ic=$((0))
for c in $cText; do
    cVal=${cs[$ic]}
    echo $c $cVal

    for scheme in ${schemes[*]}; do
        for res in 60 120; do
            let twoRes=$res*2
            case=results/c${c}_${scheme}/${twoRes}x${res}
            echo preparing case $case
            mkdir -p $case
            cp -r dummy/* $case
            sed -i 's/NY/'$res'/g' $case/constant/earthProperties
            sed -i 's/NX/'$twoRes'/g' $case/constant/earthProperties
            sed -i 's/MAXCO/'$cVal'/g' $case/system/controlDict
            sed -i 's/SCHEME/'$scheme'/g' $case/system/fvSchemes
            
            echo running case $case
            ./runAll/runOne.sh $case run
            echo done
        done
    done
    
    ic=$(($ic+1))
done

