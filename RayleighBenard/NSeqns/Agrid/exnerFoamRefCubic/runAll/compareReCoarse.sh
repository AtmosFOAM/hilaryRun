#!/bin/bash -e

# Reynolds number for RB convection - comparison between simulations

inputFiles=(implicit_dx004_dt01/Reynolds.dat
            implicit_dx004_dt02/Reynolds.dat
            implicit_dx004_dt05/Reynolds.dat
            implicit_dx004_dt1/Reynolds.dat
            implicit_dx004_dt2p5/Reynolds.dat
            implicit_dx004_dt5/Reynolds.dat
            
            explicit_dx004_dt01/Reynolds.dat
            explicit_dx004_dt02/Reynolds.dat
            explicit_dx004_dt05/Reynolds.dat
            explicit_dx004_dt1/Reynolds.dat
            explicit_dx004_dt2p5/Reynolds.dat
            explicit_dx004_dt5/Reynolds.dat
            
            ImEx_dx004_dt1/Reynolds.dat
            ImEx_dx004_dt2p5/Reynolds.dat
            ImEx_dx004_dt5/Reynolds.dat)
outFile=plots/compareReynoldsCoarse.eps
legends=("Implicit, @~D@~t = 0.1"
         "Implicit, @~D@~t = 0.2"
         "Implicit, @~D@~t = 0.5"
         "Implicit, @~D@~t = 1"
         "Implicit, @~D@~t = 2.5"
         "Implicit, @~D@~t = 5"
         
         "Explicit, @~D@~t = 0.1"
         "Exlicit, @~D@~t = 0.2"
         "Explicit, @~D@~t = 0.5"
         "Explicit, @~D@~t = 1"
         "Explicit, @~D@~t = 2.5"
         "Explicit, @~D@~t = 5"
         
         "ImEx, @~D@~t = 1"
         "ImEx, @~D@~t = 2.5"
         "ImEx, @~D@~t = 5")
pens=("0.5,black" "0.5,grey" "0.5,purple" "blue" "red" "1,green"
      "1,black,8_3" "1,grey,8_3" "1,purple,8_3" "1,blue,8_3" "1,red,8_3" "1,green,8_3"
      "1.5,blue,2_3" "1.5,red,2_3" "1.5,green,2_3")
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
            implicit_dx004_dt2p5/ReynoldsTimeMean.dat
            implicit_dx004_dt5/ReynoldsTimeMean.dat
            
            explicit_dx004_dt01/ReynoldsTimeMean.dat
            explicit_dx004_dt02/ReynoldsTimeMean.dat
            explicit_dx004_dt05/ReynoldsTimeMean.dat
            explicit_dx004_dt1/ReynoldsTimeMean.dat
            explicit_dx004_dt2p5/ReynoldsTimeMean.dat
            explicit_dx004_dt5/ReynoldsTimeMean.dat
            
            ImEx_dx004_dt1/ReynoldsTimeMean.dat
            ImEx_dx004_dt2p5/ReynoldsTimeMean.dat
            ImEx_dx004_dt5/ReynoldsTimeMean.dat)
outFile=plots/compareReynoldsTimeMeanCoarse.eps
xmax=1200
legPos=x9/0.5
source gmtPlot
ev $outFile

