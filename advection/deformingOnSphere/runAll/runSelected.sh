#!/bin/bash -e

if [ "$#" -ne 0 ]; then
    echo usage runSelected.sh
    exit
fi


cases=\
(\
#fullDeformation/MPDATA_cubedSphere_c2/cube_30
#fullDeformation/MPDATA_cubedSphere_c2/cube_60
#fullDeformation/MPDATA_latLon_c10/latLon_120x60
#fullDeformation/MPDATA_latLon_c2/latLon_120x60
fullDeformation/MPDATA_latLon/latLon_120x60
#fullDeformation/MPDATA_latLon/latLon_240x120
#fullDeformation/MPDATA_latLonRotated/latLon_120x60
#fullDeformation/MPDATA_latLonRotated/latLon_240x120
#fullDeformation/MPDATA_latLonSkipped/latLon_120x60
#fullDeformation/MPDATA_latLonSkipped/latLon_240x120



#weakDeformation/c1_MPDATA_cubedSphere_2gauge_adv/cube_15
#weakDeformation/c2_MPDATA_cubedSphere_2gauge_adv/cube_15
#weakDeformation/c4_MPDATA_cubedSphere_2gauge_adv/cube_15
#weakDeformation/c8_MPDATA_cubedSphere_2gauge_adv/cube_15

#weakDeformation/c1_MPDATA_cubedSphere_2gauge_adv/cube_30
#weakDeformation/c2_MPDATA_cubedSphere_2gauge_adv/cube_30
#weakDeformation/c4_MPDATA_cubedSphere_2gauge_adv/cube_30
#weakDeformation/c8_MPDATA_cubedSphere_2gauge_adv/cube_30

#weakDeformation/c1_MPDATA_cubedSphere_2gauge_adv/cube_60
#weakDeformation/c2_MPDATA_cubedSphere_2gauge_adv/cube_60
#weakDeformation/c4_MPDATA_cubedSphere_2gauge_adv/cube_60
#weakDeformation/c8_MPDATA_cubedSphere_2gauge_adv/cube_60

#weakDeformation/c1_MPDATA_cubedSphere_2gauge_adv/cube_120
#weakDeformation/c2_MPDATA_cubedSphere_2gauge_adv/cube_120
#weakDeformation/c4_MPDATA_cubedSphere_2gauge_adv/cube_120
#weakDeformation/c8_MPDATA_cubedSphere_2gauge_adv/cube_120

##weakDeformation/MPDATA_latLonRotated_2gauge_adv/latLon_120x60
##weakDeformation/MPDATA_latLonRotated_2gauge_adv/latLon_240x120
##weakDeformation/MPDATA_latLonRotated_2gauge_adv/latLon_480x240

##weakDeformation/MPDATA_latLonRotated_2gauge_adv/latLon_120x60
##weakDeformation/MPDATA_latLon_2gauge_adv/latLon_240x120
##weakDeformation/MPDATA_latLon_2gauge_adv/latLon_480x240

#weakDeformation/MPDATA_HRgrid_2gauge_adv/HRgrid6
#weakDeformation/MPDATA_HRgrid_2gauge_adv/HRgrid7
#weakDeformation/MPDATA_HRgrid_2gauge_adv/HRgrid8

#weakDeformation/MPDATA_latLonSkipped_2gauge_adv/latLon_240x120
#weakDeformation/MPDATA_latLonSkipped_2gauge_adv/latLon_480x240

#weakDeformation/MPDATA_tri_2gauge_adv/tri5
#weakDeformation/MPDATA_tri_2gauge_adv/tri6
#weakDeformation/MPDATA_tri_2gauge_adv/tri7
)

for case in ${cases[*]}; do
    echo running case $case
    ls -d $case
    ./runAll/runOne.sh $case run
    ./runAll/runOne.sh $case post
done
