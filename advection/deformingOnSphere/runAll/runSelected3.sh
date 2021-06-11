#!/bin/bash -e

if [ "$#" -ne 0 ]; then
    echo usage runSelected.sh
    exit
fi


cases=\
(\
weakDeformation/MPDATA_latLonSkipped_2gauge_adv/latLon_240x120
weakDeformation/MPDATA_latLonSkipped_2gauge_adv/latLon_480x240
)

for case in ${cases[*]}; do
    echo running case $case
    ls -d $case
#    ./runAll/runOne.sh $case run
    ./runAll/runOne.sh $case post
done
