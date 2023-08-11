#!/bin/bash -e

# Reynolds number for RB convection - comparison between simulations

inputFiles=(implicit_dx004_dt01/Reynolds.dat
            implicit_dx004_dt02/Reynolds.dat
            implicit_dx004_dt05/Reynolds.dat
            implicit_dx004_dt1/Reynolds.dat
            implicit_dx004_dt2/Reynolds.dat
            implicit_dx004_dt5/Reynolds.dat
            explicit_dx004_dt1/Reynolds.dat
            explicit_dx004_dt2/Reynolds.dat)
outFile=plots/compareReynoldsCoarse.eps
legends=("Implicit, @~D@~t = 0.1"
         "Implicit, @~D@~t = 0.2"
         "Implicit, @~D@~t = 0.5"
         "Implicit, @~D@~t = 1"
         "Implicit, @~D@~t = 2"
         "Implicit, @~D@~t = 5"
         "Explicit, @~D@~t = 1"
         "Explicit, @~D@~t = 2")
pens=("0.5,black" "0.5,grey" "0.5,purple" "blue" "red" "1,green"
      "1,blue,8_3" "1,red,8_3")
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
legPos=x-9/0.5
projection=X15c/10c
gv=0
source gmtPlot
ev $outFile

inputFiles=(implicit_dx004_dt01/ReynoldsTimeMean.dat
            implicit_dx004_dt02/ReynoldsTimeMean.dat
            implicit_dx004_dt05/ReynoldsTimeMean.dat
            implicit_dx004_dt1/ReynoldsTimeMean.dat
            implicit_dx004_dt2/ReynoldsTimeMean.dat
            implicit_dx004_dt5/ReynoldsTimeMean.dat
            explicit_dx004_dt1/ReynoldsTimeMean.dat
            explicit_dx004_dt2/ReynoldsTimeMean.dat)
outFile=plots/compareReynoldsTimeMeanCoarse.eps
ymin=100
ymax=210
dy=20
ddy=$dy
dyg=$dy
legPos=x9/0.5
source gmtPlot
ev $outFile

