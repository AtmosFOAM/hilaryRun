#!/bin/bash -e

# Plots the number of iterations for each case

inputFiles=(cubic_dt_8/nExnerpIter.dat
            cubic_dt_40/nExnerpIter.dat
            cubic_dt_120/nExnerpIter.dat
            cubic_dt_240/nExnerpIter.dat
            cubic_dt_400/nExnerpIter.dat)
outFile=plots/nItersCubic.eps
col=(2 2 2 2 2)
colx=1
legends=("@~D@~t = 8 s" "@~D@~t = 40 s" "@~D@~t = 120 s" "@~D@~t = 240 s" "@~D@~t = 400 s")
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
outFile=plots/nItersPer40Cubic.eps
ylabel='Pressure solver iterations per 40 seconds'
ymax=50
dy=10
ddy=$dy
dyg=$dy
source gmtPlot
ev $outFile

