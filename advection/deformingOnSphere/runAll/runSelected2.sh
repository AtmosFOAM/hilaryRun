#!/bin/bash -e

if [ "$#" -ne 0 ]; then
    echo usage runSelected.sh
    exit
fi


cases=\
(\
fullDeformation/MPDATA_latLonRotated/latLon_240x120
fullDeformation/MPDATA_latLonSkipped/latLon_240x120
)

for case in ${cases[*]}; do
    echo running case $case
    ls -d $case
    ./runAll/runOne.sh $case run
    ./runAll/runOne.sh $case post
done
