#!/bin/bash -e

# Reynolds number for RB convection - comparison between simulations

inputFiles=(Ra1e6/explicit_dx001_dt005/Reynolds.dat
            Ra1e6/explicit_dx002_dt01/Reynolds.dat
            Ra1e6/explicit_dx004_dt02/Reynolds.dat)
outFile=Ra1e6/plots/compareReynolds.eps
legends=("@~D@~x = 0.01, @~D@~t = 0.005"
         "@~D@~x = 0.02, @~D@~t = 0.01"
         "@~D@~x = 0.04, @~D@~t = 0.02")
pens=("blue" "red" "grey")
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

inputFiles=(Ra1e6/explicit_dx001_dt005/ReynoldsTimeMean.dat
            Ra1e6/explicit_dx002_dt01/ReynoldsTimeMean.dat
            Ra1e6/explicit_dx004_dt02/ReynoldsTimeMean.dat)
outFile=Ra1e6/plots/compareReynoldsTimeMean.eps
ymin=100
ymax=210
dy=20
ddy=$dy
dyg=$dy
source gmtPlot
ev $outFile

