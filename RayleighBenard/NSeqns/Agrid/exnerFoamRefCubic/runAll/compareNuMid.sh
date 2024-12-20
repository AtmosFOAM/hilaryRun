#!/bin/bash -e

# Nusselt number for RB convection - comparison between simulations

inputFiles=(Ra1e6/implicit_dx002_dt05_off0_c2_4/Nusselt.dat
            Ra1e6/implicit_dx002_dt1_off0_c2_4/Nusselt.dat
            Ra1e6/implicit_dx002_dt2.5_off0_c2_4/Nusselt.dat
            
            Ra1e6/explicit_dx002_dt01/Nusselt.dat
            Ra1e6/explicit_dx002_dt02/Nusselt.dat
            
            Ra1e6/ImEx_dx002_dt02_off0_c2_4/Nusselt.dat
            Ra1e6/ImEx_dx002_dt05_off0_c2_4/Nusselt.dat
            Ra1e6/ImEx_dx002_dt1_off0_c2_4/Nusselt.dat
            Ra1e6/ImEx_dx002_dt2.5_off0_c2_4/Nusselt.dat
            Ra1e6/ImEx_dx002_dt1_3d_off0_c2_4/Nusselt.dat
            Ra1e6/ImEx_dx002_dt1_3d_off0_c0/Nusselt.dat)
outFile=Ra1e6/plots/compareNusseltMid.eps
legends=("Implicit, @~D@~t = 0.5"
         "Implicit, @~D@~t = 1"
         "Implicit, @~D@~t = 2.5"
         
         "Explicit, @~D@~t = 0.1"
         "Exlicit, @~D@~t = 0.2"
         
         "ImEx, @~D@~t = 0.2"
         "ImEx, @~D@~t = 0.5"
         "ImEx, @~D@~t = 1"
         "ImEx, @~D@~t = 2.5"
         "ImEx, @~D@~t = 1, 3D"
         "ImEx, @~D@~t = 1, 3D, @~g@~=1")
pens=("0.5,blue" "0.5,red" "0.5,green"
      "1,black,8_3" "1,blue,8_3"
      "1.5,black,2_3" "1.5,blue,2_3" "1.5,red,2_3" "1.5,green,2_3"
      "2,magenta,2_3" "0.5,magenta,4_3")
col=2
colx=1
xlabel="Time"
ylabel="Nusselt number"
xmin=0
xmax=1000
dx=200
ymin=0
ymax=15
dy=5
ddy=$dy
dyg=$dy
xscale=/1
yscale=/1
nSkip=1
legPos=x9/0
projection=X15c/10c
gv=0
source gmtPlot
ev $outFile

