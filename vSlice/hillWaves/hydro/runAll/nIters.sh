#!/bin/bash -e

# Plots the number of iterations for each case

inputFiles=(dt20_stdRes/nExnerpIter.dat
            dt100_stdRes/nExnerpIter.dat
            dt200_stdRes/nExnerpIter.dat
            dt500_stdRes/nExnerpIter.dat
            dt1000_stdRes/nExnerpIter.dat)
outFile=plots/nIters.eps
col=(2 2 2 2 2)
colx=1
legends=("@~D@~t = 20" "@~D@~t = 100" "@~D@~t = 200" "@~D@~t = 500" "@~D@~t = 1000")
pens=("black"  "blue,5_5:"  "1,red,1_2:" "1,cyan,4_8:2" "1,magenta,4_8_1_8:3")
xlabel='Time (s)'
ylabel='Total pressure solver iterations'
xmin=0
xmax=15000
dx=3000
ddx=$dx
ymin=0
ymax=650
dy=100
ddy=$dy
dyg=$dy
yscale=*1
legPos=x9/5.5
nSkip=1
projection=X12c/8c
gv=0

#source gmtPlot
#ev $outFile

yscale=(/1 /5 /10 /25 /50)
outFile=plots/nItersPer20.eps
ylabel='Pressure solver iterations per 20 seconds'
ymax=30
dy=10
ddy=$dy
dyg=$dy
source gmtPlot
ev $outFile

