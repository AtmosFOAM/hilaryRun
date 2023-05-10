#!/bin/bash -e

mkdir -p plots
gmtPlot ../gmtDicts/energy.gmt
ev plots/energy.eps

if [ -a processor0 ]; then
    reconstructPar -fields '(Uf w)' -latestTime
fi
gmtFoam -latestTime wAll
ev `ls -1rt */wAll.pdf | tail -1`
#rm [0-9]*/U[x-z]

