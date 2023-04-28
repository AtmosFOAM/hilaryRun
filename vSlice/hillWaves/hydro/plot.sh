#!/bin/bash -e

if [ -a processor0 ]; then
    reconstructPar -fields '(Uf U)' -latestTime
fi
writeuvw -latestTime U
gmtFoam -latestTime wAll
ev `ls -1rt */wAll.pdf | tail -1`
rm [0-9]*/U[x-z]

gmtPlot ../gmtDicts/energy.gmt

