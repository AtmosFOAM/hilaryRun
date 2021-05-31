#!/bin/bash -e

#if [ "$#" -ne 0 ]; then
#    echo usage runAll.sh
#    exit
#fi

cs=(0.8 1.6 8)
cText="08 1p6 8"

#schemes=("MPDATA_CN" "upwind")
#schemesText=("MPDATA_CN 1" " Gauss upwind")
schemes=("MPDATA_CN")
schemesText=("MPDATA_CN 1")
echo ${schemes[*]}


#for res in 60 120 240 360; do
for res in 120 240 360; do
    twoRes=$(($res*2))

    is=$((0))
    for scheme in ${schemes[*]}; do
        schemeText=${schemesText[$is]}
        echo s/SCHEME/"$schemeText"/g

        ic=$((0))
        for c in $cText; do
            cVal=${cs[$ic]}
            echo $c $cVal

            case=results/c${c}_${scheme}/${twoRes}x${res}
            echo preparing case $case
            mkdir -p $case
            cp -r dummy/* $case
            sed -i 's/NY/'$res'/g' $case/constant/earthProperties
            sed -i 's/NX/'$twoRes'/g' $case/constant/earthProperties
            sed -i 's/MAXCO/'$cVal'/g' $case/system/controlDict
            sed -i 's/SCHEME/'"$schemeText"'/g' $case/system/fvSchemes
            
            echo running case $case
            ./runAll/runOne.sh $case run
            ic=$(($ic+1))
        done
    done
    is=$(($is+1))
done

