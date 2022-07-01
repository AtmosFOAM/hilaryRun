#!/bin/bash -e

# Plot the number of iterations per time step for select simulations

# Assemble max Courant number for different grids

cases="fullDeformation/MPDATA_latLonPolar_c1/latLon_120x60
       fullDeformation/MPDATA_latLonPolar_c1/latLon_240x120
       fullDeformation/MPDATA_latLonPolar_c1/latLon_480x240
       fullDeformation/MPDATA_latLonPolar_c2/latLon_120x60
       fullDeformation/MPDATA_latLonPolar_c2/latLon_240x120
       fullDeformation/MPDATA_latLonPolar_c2/latLon_480x240
       fullDeformation/MPDATA_latLonPolar_c10/latLon_120x60
       fullDeformation/MPDATA_latLonPolar_c10/latLon_240x120
       fullDeformation/MPDATA_latLonPolar_c10/latLon_480x240"

inputFiles=''

for case in $cases; do
    if [[ -a $case/log ]]; then
        inputFiles=(${inputFiles[*]} $case/iterations.dat)

        grep 'DILUPBiCGStab' $case/log | awk '(NR>1){print $15}' > $case/iterations.dat
        grep 'Time =' $case/log | awk '{print $3}' >> $case/time.dat
        paste $case/time.dat $case/iterations.dat  | sponge $case/time.dat
        echo '#Time nIterations' > $case/iterations.dat
        cat $case/time.dat >> $case/iterations.dat
        rm $case/time.dat
    fi
done

outFile=plots/iterations.eps
col=2
colx=1
pens=("black" "0.5p,black,6_4:0" "1p,black,1_2:0"
      "blue" "0.5p,blue,6_4:1" "1p,blue,1_2:1"
      "red"  "0.5p,red,6_4:2"  "1p,red,1_2:1"
      "green" "0.5p,green,6_4:3" "1p,green,1_2:3")
legends=("120x60, @~D@~t = 0.01, c<1"
         "240x120, @~D@~t = 0.005, c<1"
         "480x240, @~D@~t = 0.0025, c<1"
         
         "120x60, @~D@~t = 0.02, c<2"
         "240x120, @~D@~t = 0.01, c<2"
         "480x240, @~D@~t = 0.005, c<2"
         
         "120x60, @~D@~t = 0.1, c<10"
         "240x120, @~D@~t = 0.05, c<10"
         "480x240, @~D@~t = 0.025, c<10"
         )

xlabel='time'
ylabel=''
xmin=0
xmax=5
dx=1
ddx=0
dxg=0
ymin=0
ymax=20
dy=5
ddy=0
dyg=0
xscale=*1
yscale=*1
legPos=x8.5/-1.5
projection=X8c/4c
gv=0

. gmtPlot

