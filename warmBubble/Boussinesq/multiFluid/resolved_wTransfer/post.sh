#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: ./post.sh time
   exit
fi

time=$1
gmtFoam -time $time P
gvu $time/P.pdf
writeuvw -time $time u.stable
writeuvw -time $time u.buoyant
sumFields $time massTransfer $time massTransfer.stable.buoyant $time massTransfer.buoyant.stable -scale1 -1
gmtFoam -time $time massTransfer
gvu $time/massTransfer.pdf
gmtFoam -time $time b0
gvu $time/b0.pdf
gmtFoam -time $time b1
gvu $time/b1.pdf

