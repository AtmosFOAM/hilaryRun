#!/bin/bash -e

reconstructPar -fields '(Uf)' -latestTime
writeuvw -latestTime Uf
gmtFoam -latestTime w
ev `ls -1rt */w.pdf | tail -1`

