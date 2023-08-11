#!/bin/bash -e

# Nusselt number for RB convection - comparison between simulations

inputFiles=(implicit_dx001_dt0025/Reynolds.dat
            implicit_dx001_dt005/Reynolds.dat
            implicit_dx002_dt005/Reynolds.dat
            implicit_dx002_dt01/Reynolds.dat
            implicit_dx004_dt01/Reynolds.dat
            implicit_dx004_dt02/Reynolds.dat
            implicit_dx004_dt05/Reynolds.dat)
outFile=plots/compareReynolds.eps
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
ylabel="Reynolds number"
xmin=0
xmax=1000
dx=200
ymin=0
ymax=250
dy=50
ddy=$dy
dyg=$dy
xscale=/1
yscale=/1
nSkip=1
legPos=x9/2
projection=X15c/10c
gv=0
source gmtPlot
ev $outFile

inputFiles=(implicit_dx001_dt0025/ReynoldsTimeMean.dat
            implicit_dx001_dt005/ReynoldsTimeMean.dat
            implicit_dx002_dt005/ReynoldsTimeMean.dat
            implicit_dx002_dt01/ReynoldsTimeMean.dat
            implicit_dx004_dt01/ReynoldsTimeMean.dat
            implicit_dx004_dt02/ReynoldsTimeMean.dat
            implicit_dx004_dt05/ReynoldsTimeMean.dat)
outFile=plots/compareReynoldsTimeMean.eps
ymin=100
ymax=210
dy=20
ddy=$dy
dyg=$dy
source gmtPlot
ev $outFile

