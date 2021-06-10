#!/bin/bash -e

if [ "$#" -ne 0 ]; then
    echo usage runSelected.sh
    exit
fi


cases=\
(\
weakDeformation/c1_MPDATA_cubedSphere_2gauge_adv/cube_15
weakDeformation/c2_MPDATA_cubedSphere_2gauge_adv/cube_15
weakDeformation/c4_MPDATA_cubedSphere_2gauge_adv/cube_15
weakDeformation/c8_MPDATA_cubedSphere_2gauge_adv/cube_15

weakDeformation/c1_MPDATA_cubedSphere_2gauge_adv/cube_30
weakDeformation/c2_MPDATA_cubedSphere_2gauge_adv/cube_30
weakDeformation/c4_MPDATA_cubedSphere_2gauge_adv/cube_30
weakDeformation/c8_MPDATA_cubedSphere_2gauge_adv/cube_30

weakDeformation/c1_MPDATA_cubedSphere_2gauge_adv/cube_60
weakDeformation/c2_MPDATA_cubedSphere_2gauge_adv/cube_60
weakDeformation/c4_MPDATA_cubedSphere_2gauge_adv/cube_60
weakDeformation/c8_MPDATA_cubedSphere_2gauge_adv/cube_60

weakDeformation/c1_MPDATA_cubedSphere_2gauge_adv/cube_120
weakDeformation/c2_MPDATA_cubedSphere_2gauge_adv/cube_120
weakDeformation/c4_MPDATA_cubedSphere_2gauge_adv/cube_120
weakDeformation/c8_MPDATA_cubedSphere_2gauge_adv/cube_120

#weakDeformation/MPDATA_latLonRotated_2gauge_adv/latLon_120x60
#weakDeformation/MPDATA_latLonRotated_2gauge_adv/latLon_240x120
#weakDeformation/MPDATA_latLonRotated_2gauge_adv/latLon_480x240

#weakDeformation/MPDATA_latLonRotated_2gauge_adv/latLon_120x60
#weakDeformation/MPDATA_latLon_2gauge_adv/latLon_240x120
#weakDeformation/MPDATA_latLon_2gauge_adv/latLon_480x240
)

for case in ${cases[*]}; do
    echo running case $case
    ls -d $case
    ./runAll/runOne.sh $case run
#    ./runAll/runOne.sh $case post
done
