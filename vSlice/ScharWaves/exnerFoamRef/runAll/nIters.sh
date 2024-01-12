#!/bin/bash -e

# Plots the number of iterations for each case

inputFiles=(dt_8/nExnerpIter.dat
            dt_40/nExnerpIter.dat
            dt_120/nExnerpIter.dat
            dt_240/nExnerpIter.dat
            dt_400/nExnerpIter.dat)
outFile=plots/nIters.eps
col=(2 2 2 2 2)
colx=1
legends=("@~D@~t = 8" "@~D@~t = 40" "@~D@~t = 120" "@~D@~t = 240" "@~D@~t = 400")
pens=("black"  "blue,5_5:"  "1,red,1_2:" "1,cyan,4_8:2" "1,magenta,4_8_1_8:3" "green")
xlabel='Time (s)'
ylabel='Total pressure solver iterations'
xmin=0
xmax=18000
dx=3000
ddx=$dx
ymin=0
ymax=50
dy=10
ddy=$dy
dyg=$dy
yscale=*1
legPos=x9/5.5
nSkip=1
projection=X12c/8c
gv=0

source gmtPlot
ev $outFile

yscale=(*5 /1 /3 /6 /10)
outFile=plots/nItersPer40.eps
ylabel='Pressure solver iterations per 40 seconds'
ymax=50
dy=10
ddy=$dy
dyg=$dy
source gmtPlot
ev $outFile

