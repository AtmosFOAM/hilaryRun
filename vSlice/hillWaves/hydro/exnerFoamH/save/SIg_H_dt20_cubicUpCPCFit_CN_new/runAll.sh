#!/bin/bash -e

export case=.
rm -f energy.dat
touch energy.dat
tail -f energy.dat | awk '{print $1/3600, $2, $3, $4, $5, $6}' &
exnerFoamH > log 2>&1
time=15000
gmtFoam -case $case -time $time w
gv $case/$time/w.pdf &
sumFields -case $case $time thetaDiff $time theta 0 theta -scale1 -1
gmtFoam -case $case -time $time thetaDiff
gv $case/$time/thetaDiff.pdf &
tailPID=`ps | grep tail | awk '{print $1}'`
kill $tailPID

