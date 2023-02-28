#!/bin/bash -e

caseRoot=runs/BTBS

# Plot options for all plots
col=(4 4 4 4 4)
colx=1
pens=("black" "blue" "red,5_5:0" "cyan,2_5:0" "magenta,2_4:1" "1,green,1_3:0")
legends=("0" "1" "2" "5" "10" "20")
#xlabel='x'
xmin=0
xmax=1
dx=0.2
ddx=0
dxg=0
ymin=0
ymax=1
dy=0.2
ddy=0
dyg=1
xscale=*1
yscale=("*1" "*1")
legPos=x13/4
projection=X15c/7c
gv=0


# Plot all
time=0.1
for solver in PBiCGStab GAMG  ; do
    echo ${caseRoot}_it${nIter}_${solver}
    
    inputFiles=()
    for nIter in 0 1 2 5 10 20; do
        case=${caseRoot}_it${nIter}_${solver}
        inputFiles=(${inputFiles[*]} $case/$time/T.xyz)
    done
    outFile=${caseRoot}_${solver}.eps
    . gmtPlot
done


