#!/bin/bash -e

if [ "$#" -ne 0 ]; then
    echo usage runSelected.sh
    exit
fi


cases=\
(\
#fullDeformation/MPDATA_latLon_c1/latLon_240x120
fullDeformation/MPDATA_latLon_c1/latLon_480x240
fullDeformation/MPDATA_latLon_c2/latLon_480x240
fullDeformation/MPDATA_latLon_c10/latLon_480x240
fullDeformation/MPDATA_latLonRotated/latLon_240x120
fullDeformation/MPDATA_latLonRotated/latLon_480x240
fullDeformation/MPDATA_latLonSkipped/latLon_240x120
fullDeformation/MPDATA_latLonSkipped/latLon_480x240

)

for case in ${cases[*]}; do
    echo running case $case
    ls -d $case
    ./runAll/runOne.sh $case run
    ./runAll/runOne.sh $case post
done
