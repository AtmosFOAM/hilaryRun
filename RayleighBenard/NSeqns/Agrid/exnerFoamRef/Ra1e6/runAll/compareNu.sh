#!/bin/bash -e

# Nusselt number for RB convection - comparison between simulations

inputFiles=(implicit_dx001_dt0025/Nusselt.dat
            implicit_dx001_dt005/Nusselt.dat
            implicit_dx002_dt005/Nusselt.dat
            implicit_dx002_dt01/Nusselt.dat
            implicit_dx004_dt01/Nusselt.dat
            implicit_dx004_dt02/Nusselt.dat
            implicit_dx004_dt05/Nusselt.dat)
outFile=plots/compareNusselt.eps
legends=("@~D@~x = 0.01, c < 0.2"
         "@~D@~x = 0.01, c < 0.4"
         "@~D@~x = 0.02, c < 0.2"
         "@~D@~x = 0.02, c < 0.4"
         "@~D@~x = 0.04, c < 0.2"
         "@~D@~x = 0.04, c < 0.4"
         "@~D@~x = 0.04, c < 0.8")
pens=("black" "black,5_5" "blue" "blue,5_5" "red" "red,5_5" "red,2_4")
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

inputFiles=(implicit_dx001_dt0025/NusseltTimeMean.dat
            implicit_dx001_dt005/NusseltTimeMean.dat
            implicit_dx002_dt005/NusseltTimeMean.dat
            implicit_dx002_dt01/NusseltTimeMean.dat
            implicit_dx004_dt01/NusseltTimeMean.dat
            implicit_dx004_dt02/NusseltTimeMean.dat
            implicit_dx004_dt05/NusseltTimeMean.dat)
outFile=plots/compareNusseltTimeMean.eps
ymin=1
ymax=9
dy=1
ddy=$dy
dyg=$dy
source gmtPlot
ev $outFile

