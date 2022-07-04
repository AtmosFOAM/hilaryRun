#!/bin/bash -e

if [ "$#" -ne 1 ]; then
    echo usage 'plotT2p5.sh'
    exit
fi

case=$1

gmtFoam -case $case -time 2.5 TrawUnder
gmtFoam -case $case -time 5 CoOver
cat $case/2.5/TrawUnder.ps $case/5/CoOver.ps > $case/2.5/TCo.eps
makebb $case/2.5/TCo.eps
epstopdf $case/2.5/TCo.eps
ev $case/2.5/TCo.pdf
rm $case/2.5/TrawUnder.ps $case/5/CoOver.ps $case/2.5/TCo.eps
echo $case/2.5/TCo.pdf
