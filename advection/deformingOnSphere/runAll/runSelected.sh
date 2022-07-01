#!/bin/bash -e

if [ "$#" -ne 0 ]; then
    echo usage runSelected.sh
    exit
fi


cases=\
(\
MPDATA_latLonPolar_c1 MPDATA_latLonPolar_c2 MPDATA_latLonPolar_c10 \ MPDATA_latLonPolarRotated_c2 MPDATA_HRgrid_c2 MPDATA_HRgrid_c10 \
)

for case in ${cases[*]}; do
    for dir in fullDeformation/$case/*; do
        echo running case $dir
#        ./runAll/runOne.sh $dir init
#        ./runAll/runOne.sh $dir run
        ./runAll/runOne.sh $dir post
    done
done
