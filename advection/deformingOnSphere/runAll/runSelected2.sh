#!/bin/bash -e

if [ "$#" -ne 0 ]; then
    echo usage runSelected.sh
    exit
fi


cases=\
(\
weakDeformation/MPDATA_tri_2gauge_adv/tri5
weakDeformation/MPDATA_tri_2gauge_adv/tri6
weakDeformation/MPDATA_tri_2gauge_adv/tri7

)

for case in ${cases[*]}; do
    echo running case $case
    ls -d $case
    ./runAll/runOne.sh $case run
#    ./runAll/runOne.sh $case post
done
