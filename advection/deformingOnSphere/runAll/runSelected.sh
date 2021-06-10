#!/bin/bash -e

if [ "$#" -ne 0 ]; then
    echo usage runSelected.sh
    exit
fi


cases=\
(\
#weakDeformation/c8_MPDATA_cubedSphere_2gauge_adv/cube_15
#weakDeformation/c1p6_MPDATA_cubedSphere_2gauge_adv/cube_15
weakDeformation/c3_MPDATA_cubedSphere_2gauge_adv/cube_15
#weakDeformation/c08_MPDATA_cubedSphere_2gauge_adv/cube_15

#weakDeformation/c8_MPDATA_cubedSphere_2gauge_adv/cube_30
#weakDeformation/c1p6_MPDATA_cubedSphere_2gauge_adv/cube_30
weakDeformation/c3_MPDATA_cubedSphere_2gauge_adv/cube_30
#weakDeformation/c08_MPDATA_cubedSphere_2gauge_adv/cube_30

#weakDeformation/c8_MPDATA_cubedSphere_2gauge_adv/cube_60
#weakDeformation/c1p6_MPDATA_cubedSphere_2gauge_adv/cube_60
weakDeformation/c3_MPDATA_cubedSphere_2gauge_adv/cube_60
#weakDeformation/c08_MPDATA_cubedSphere_2gauge_adv/cube_60

weakDeformation/c8_MPDATA_cubedSphere_2gauge_adv/cube_120
weakDeformation/c1p6_MPDATA_cubedSphere_2gauge_adv/cube_120
weakDeformation/c3_MPDATA_cubedSphere_2gauge_adv/cube_120
weakDeformation/c08_MPDATA_cubedSphere_2gauge_adv/cube_120
)

for case in ${cases[*]}; do
    echo running case $case
    ls -d $case
#    ./runAll/runOne.sh $case run
    ./runAll/runOne.sh $case post
done