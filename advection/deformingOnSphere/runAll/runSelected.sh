#!/bin/bash -e

if [ "$#" -ne 0 ]; then
    echo usage runSelected.sh
    exit
fi


cases=\
(\
fullDeformation/MPDATA_latLonRotated_c2
)

for case in ${cases[*]}; do
    for dir in $case/*; do
        echo running case $dir
        ./runAll/runOne.sh $dir init
        ./runAll/runOne.sh $dir run
#        ./runAll/runOne.sh $dir post
    done
done

#cases=\
#(\
#    fullDeformation/MPDATA_HRgrid_c10/HRgrid7
#    fullDeformation/MPDATA_HRgrid_c2/HRgrid7
#    fullDeformation/MPDATA_latLonPolar_c1/latLon_240x120
#    fullDeformation/MPDATA_latLonPolar_c10/latLon_240x120
#    fullDeformation/MPDATA_latLonPolar_c2/latLon_240x120
#)
#for case in ${cases[*]}; do
#    gmtFoam -time 2.5 -case $case Traw
#    ev $case/2.5/Traw.pdf
#done

