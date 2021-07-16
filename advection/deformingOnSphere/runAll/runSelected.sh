#!/bin/bash -e

if [ "$#" -ne 0 ]; then
    echo usage runSelected.sh
    exit
fi


cases=\
(\
fullDeformation/MPDATA_cubedSphere_gauge_c2/cube_30
fullDeformation/MPDATA_cubedSphere_gauge_c2/cube_60
fullDeformation/MPDATA_cubedSphere_gauge_c2/cube_120
)

for case in ${cases[*]}; do
    echo running case $case
    ls -d $case
    ./runAll/runOne.sh $case init
    ./runAll/runOne.sh $case run
    ./runAll/runOne.sh $case post
done
