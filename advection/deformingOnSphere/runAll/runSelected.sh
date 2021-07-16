#!/bin/bash -e

if [ "$#" -ne 0 ]; then
    echo usage runSelected.sh
    exit
fi


cases=\
(\
fullDeformation/MPDATA_latLonSkipped_gauge/latLon_120x60
fullDeformation/MPDATA_latLonSkipped_gauge/latLon_240x120
fullDeformation/MPDATA_latLonSkipped_gauge/latLon_480x240
)

for case in ${cases[*]}; do
    echo running case $case
    ls -d $case
    ./runAll/runOne.sh $case init
    ./runAll/runOne.sh $case run
    ./runAll/runOne.sh $case post
done
