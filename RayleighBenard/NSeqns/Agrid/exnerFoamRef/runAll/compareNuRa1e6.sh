#!/bin/bash -e

# Nusselt number for RB convection - comparison between simulations

inputFiles=(Ra1e6/explicit_dx001_dt005/Nusselt.dat
            Ra1e6/explicit_dx002_dt01/Nusselt.dat
            Ra1e6/explicit_dx004_dt02/Nusselt.dat)
outFile=Ra1e6/plots/compareNusselt.eps
legends=("@~D@~x = 0.01, @~D@~t = 0.005"
         "@~D@~x = 0.02, @~D@~t = 0.01"
         "@~D@~x = 0.04, @~D@~t = 0.02")
pens=("blue" "red" "grey")
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
legPos=x9/0.5
projection=X15c/10c
gv=0
source gmtPlot
ev $outFile

inputFiles=(Ra1e6/explicit_dx001_dt005/NusseltTimeMean.dat
            Ra1e6/explicit_dx002_dt01/NusseltTimeMean.dat
            Ra1e6/explicit_dx004_dt02/NusseltTimeMean.dat)
outFile=Ra1e6/plots/compareNusseltTimeMean.eps
ymin=1
ymax=9
dy=1
ddy=$dy
dyg=$dy
source gmtPlot
ev $outFile

inputFiles=(Ra1e6/explicit_dx001_dt005/NusseltTopBotTimeMean.dat
            Ra1e6/explicit_dx002_dt01/NusseltTopBotTimeMean.dat
            Ra1e6/explicit_dx004_dt02/NusseltTopBotTimeMean.dat)
outFile=Ra1e6/plots/compareNusseltTopBotTimeMean.eps
ymin=1
ymax=9
dy=1
ddy=$dy
dyg=$dy
source gmtPlot
ev $outFile

