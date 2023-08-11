#!/bin/bash -e

# Nusselt number for RB convection - comparison between simulations

inputFiles=(implicit_dx004_dt01/Nusselt.dat
            implicit_dx004_dt02/Nusselt.dat
            implicit_dx004_dt05/Nusselt.dat
            implicit_dx004_dt1/Nusselt.dat
            implicit_dx004_dt2p5/Nusselt.dat
            implicit_dx004_dt5/Nusselt.dat
            
            explicit_dx004_dt01/Nusselt.dat
            explicit_dx004_dt02/Nusselt.dat
            explicit_dx004_dt05/Nusselt.dat
            explicit_dx004_dt1/Nusselt.dat
            explicit_dx004_dt2p5/Nusselt.dat
            explicit_dx004_dt5/Nusselt.dat
            
            ImEx_dx004_dt1/Nusselt.dat
            ImEx_dx004_dt2p5/Nusselt.dat
            ImEx_dx004_dt5/Nusselt.dat)
outFile=plots/compareNusseltCoarse.eps
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
legPos=x-9/0.5
projection=X15c/10c
gv=0
source gmtPlot
ev $outFile

inputFiles=(implicit_dx004_dt01/NusseltTimeMean.dat
            implicit_dx004_dt02/NusseltTimeMean.dat
            implicit_dx004_dt05/NusseltTimeMean.dat
            implicit_dx004_dt1/NusseltTimeMean.dat
            implicit_dx004_dt2p5/NusseltTimeMean.dat
            implicit_dx004_dt5/NusseltTimeMean.dat
            
            explicit_dx004_dt01/NusseltTimeMean.dat
            explicit_dx004_dt02/NusseltTimeMean.dat
            explicit_dx004_dt05/NusseltTimeMean.dat
            explicit_dx004_dt1/NusseltTimeMean.dat
            explicit_dx004_dt2p5/NusseltTimeMean.dat
            explicit_dx004_dt5/NusseltTimeMean.dat
            
            ImEx_dx004_dt1/NusseltTimeMean.dat
            ImEx_dx004_dt2p5/NusseltTimeMean.dat
            ImEx_dx004_dt5/NusseltTimeMean.dat)
outFile=plots/compareNusseltTimeMeanCoarse.eps
ymin=6
ymax=9
xmax=1200
dy=1
ddy=$dy
dyg=$dy
legPos=x10.7/0.5
source gmtPlot
ev $outFile

inputFiles=(implicit_dx004_dt01/NusseltTopBotTimeMean.dat
            implicit_dx004_dt02/NusseltTopBotTimeMean.dat
            implicit_dx004_dt05/NusseltTopBotTimeMean.dat
            implicit_dx004_dt1/NusseltTopBotTimeMean.dat
            implicit_dx004_dt2p5/NusseltTopBotTimeMean.dat
            implicit_dx004_dt5/NusseltTopBotTimeMean.dat
            
            explicit_dx004_dt01/NusseltTopBotTimeMean.dat
            explicit_dx004_dt02/NusseltTopBotTimeMean.dat
            explicit_dx004_dt05/NusseltTopBotTimeMean.dat
            explicit_dx004_dt1/NusseltTopBotTimeMean.dat
            explicit_dx004_dt2p5/NusseltTopBotTimeMean.dat
            explicit_dx004_dt5/NusseltTopBotTimeMean.dat
            
            ImEx_dx004_dt1/NusseltTopBotTimeMean.dat
            ImEx_dx004_dt2p5/NusseltTopBotTimeMean.dat
            ImEx_dx004_dt5/NusseltTopBotTimeMean.dat)
outFile=plots/compareNusseltTopBot.eps
ymin=6.8
ymax=8.4
xmax=1300
dy=1
ddy=$dy
dyg=$dy
legPos=x10.7/0.5
source gmtPlot
ev $outFile
