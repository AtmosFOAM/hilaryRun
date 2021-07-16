#!/bin/bash -e

if [ "$#" -ne 0 ]; then
    echo usage runSelected.sh
    exit
fi


cases=\
(\
fullDeformation/MPDATA_HRgrid_gauge_c2/HRgrid6
fullDeformation/MPDATA_HRgrid_gauge_c2/HRgrid7
fullDeformation/MPDATA_HRgrid_gauge_c2/HRgrid8
)

for case in ${cases[*]}; do
    echo running case $case
    ls -d $case
    ./runAll/runOne.sh $case init
    ./runAll/runOne.sh $case run
    ./runAll/runOne.sh $case post
done
