#!/bin/bash -e

if [ "$#" -ne 0 ]; then
    echo usage runSelected.sh
    exit
fi


cases=\
(\
weakDeformation/MPDATA_HRgrid_2gauge_adv/HRgrid6
weakDeformation/MPDATA_HRgrid_2gauge_adv/HRgrid7
weakDeformation/MPDATA_HRgrid_2gauge_adv/HRgrid8
)

for case in ${cases[*]}; do
    echo running case $case
    ls -d $case
    ./runAll/runOne.sh $case run
#    ./runAll/runOne.sh $case post
done
